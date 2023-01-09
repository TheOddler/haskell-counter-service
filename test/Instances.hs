{-# OPTIONS_GHC -Wno-orphans #-}

module Instances where

import Key (Key (..))
import Test.Hspec.Wai.QuickCheck (Arbitrary (..))
import Test.QuickCheck (elements, listOf)

instance Arbitrary Key where
  arbitrary = Key <$> listOf (elements ['a' .. 'z'])
