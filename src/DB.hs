{-# LANGUAGE OverloadedStrings #-}

module DB where

import Control.Exception (bracket)
import Control.Monad.IO.Class (MonadIO (liftIO))
import Control.Monad.Reader (asks)
import Data.ByteString (ByteString)
import Data.Int (Int64)
import Data.Pool (Pool, PoolConfig (..), newPool, withResource)
import Database.PostgreSQL.Simple (Connection, Query, close, connectPostgreSQL)
import qualified Database.PostgreSQL.Simple as Postgres
import Database.PostgreSQL.Simple.FromRow (FromRow)
import Database.PostgreSQL.Simple.ToRow (ToRow)
import Handler (Environment (..), Handler)

type DBConnectionString = ByteString

initDB :: DBConnectionString -> IO ()
initDB connStr = bracket (connectPostgreSQL connStr) close $ \conn -> do
  _ <-
    Postgres.execute_
      conn
      "CREATE TABLE IF NOT EXISTS submissions (input TEXT PRIMARY KEY NOT NULL, count INT NOT NULL)"
  return ()

initConnectionPool :: DBConnectionString -> IO (Pool Connection)
initConnectionPool connStr =
  newPool
    PoolConfig
      { createResource = connectPostgreSQL connStr,
        freeResource = close,
        poolCacheTTL = 60,
        poolMaxResources = 10
      }

query :: (ToRow p, FromRow r) => Query -> p -> Handler [r]
query q params = do
  pool <- asks dbConnectionPool
  liftIO $
    withResource pool $ \conn ->
      Postgres.query conn q params

execute :: ToRow p => Query -> p -> Handler Int64
execute q params = do
  pool <- asks dbConnectionPool
  liftIO $
    withResource pool $ \conn ->
      Postgres.execute conn q params
