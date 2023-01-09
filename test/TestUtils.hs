{-# LANGUAGE OverloadedStrings #-}

module TestUtils where

import DB (initConnectionPool, initDB)
import Data.ByteString (ByteString)
import qualified Data.ByteString.Lazy as LB
import Database.Postgres.Temp (toConnectionString)
import qualified Database.Postgres.Temp as PostgresTemp
import Handler (Environment (..))
import Network.HTTP.Types (hContentType)
import Network.HTTP.Types.Method (methodPost)
import Network.Wai.Test (SResponse)
import Servant.Server (Application)
import Server (application)
import Test.Hspec.Wai (WaiSession, request)

withServer :: (((), Application) -> IO a) -> IO a
withServer f = do
  eitherErrOrA <- PostgresTemp.with $ \db -> do
    let connStr = toConnectionString db
    conns <- initConnectionPool connStr
    initDB connStr
    let env =
          Environment
            { dbConnectionPool = conns
            }
    f ((), application env)

  case eitherErrOrA of
    Left err -> error $ show err
    Right a -> pure a

postJson :: ByteString -> LB.ByteString -> WaiSession st SResponse
postJson path = request methodPost path [(hContentType, "application/json")]
