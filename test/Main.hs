{-# LANGUAGE OverloadedStrings #-}

module Main (main) where

import qualified Api.GetQuerySpec
import qualified Api.PostInputSpec
import Test.Hspec (hspec)

main :: IO ()
main = hspec $ do
  Api.GetQuerySpec.spec
  Api.PostInputSpec.spec
