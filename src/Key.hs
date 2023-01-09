{-# LANGUAGE DerivingStrategies #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}

module Key where

import Data.Aeson.Types (FromJSON)
import Database.PostgreSQL.Simple.ToField (ToField)
import Servant (FromHttpApiData)

newtype Key = Key {unKey :: String}
  deriving (Show)
  deriving newtype (FromJSON, FromHttpApiData, ToField)
