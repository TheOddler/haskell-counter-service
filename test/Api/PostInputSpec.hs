{-# LANGUAGE OverloadedStrings #-}

module Api.PostInputSpec (spec) where

import Test.Hspec (Spec, around, describe, it)
import Test.Hspec.Wai (shouldRespondWith)
import TestUtils (postJson, withServer)

spec :: Spec
spec = around withServer $ do
  describe "POST /input" $ do
    it "should accept valid keys" $
      postJson "/input" "\"test\"" `shouldRespondWith` 204
    it "should reject invalid keys" $
      postJson "/input" "invalidKeyBecauseQuotesAreMissing" `shouldRespondWith` 400
