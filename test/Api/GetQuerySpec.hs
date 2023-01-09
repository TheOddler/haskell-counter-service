{-# LANGUAGE InstanceSigs #-}
{-# LANGUAGE OverloadedStrings #-}

module Api.GetQuerySpec (spec) where

import Control.Monad (replicateM_)
import Data.ByteString.Char8 (pack)
import qualified Data.ByteString.Lazy.Char8 as LB
import Instances ()
import Key (Key (..))
import Test.Hspec (Spec, around, describe, it)
import Test.Hspec.QuickCheck (modifyMaxShrinks, modifyMaxSuccess)
import Test.Hspec.Wai (ResponseMatcher (..), get, shouldRespondWith)
import Test.Hspec.Wai.Matcher (bodyEquals)
import Test.Hspec.Wai.QuickCheck (property)
import TestUtils (postJson, withServer)

spec :: Spec
spec = around withServer $ do
  -- Since setting up the database is a bit slow, we'll limit this to 10 examples
  -- Also, for some reason when shrinking it breaks the database connection, so disable that
  -- TODO: Figure out why shrinking breaks the connection, and re-enable it
  modifyMaxSuccess (const 10) $
    modifyMaxShrinks (const 0) $
      describe "GET /query" $ do
        it "should return 0 for unknown keys" $ property $ \key -> do
          get ("/query?key=" <> pack key) `shouldRespondWith` "0"

        it "should return 1 if key was posted once" $ property $ \key' -> do
          let key = unKey key'
          postJson "/input" ("\"" <> LB.pack key <> "\"") `shouldRespondWith` 204
          get ("/query?key=" <> pack key) `shouldRespondWith` "1"

        it "should return x if key was posted x times" $ property $ \(key', count') -> do
          let key = unKey key'
          let count = abs count'
          replicateM_ count $
            postJson "/input" ("\"" <> LB.pack key <> "\"")
          let countMatcher :: ResponseMatcher
              countMatcher = ResponseMatcher 200 [] $ bodyEquals $ LB.pack $ show count
          get ("/query?key=" <> pack key) `shouldRespondWith` countMatcher
