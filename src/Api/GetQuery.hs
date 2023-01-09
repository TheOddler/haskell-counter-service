{-# LANGUAGE DataKinds #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TypeOperators #-}

module Api.GetQuery where

import DB (query)
import Database.PostgreSQL.Simple (Only (..))
import Database.PostgreSQL.Simple.FromField ()
import Database.PostgreSQL.Simple.FromRow ()
import Database.PostgreSQL.Simple.ToRow ()
import Handler (Handler)
import Key (Key)
import Servant (Get, JSON, QueryParam', Required, type (:>))

-- Consider using Integer for arbitrary size int if needed
type GetQuery = "query" :> QueryParam' '[Required] "key" Key :> Get '[JSON] Int

getQuery :: Key -> Handler Int
getQuery key = do
  res <- query "SELECT count FROM submissions WHERE input = ?" (Only key)
  case res of
    [] -> return 0
    (Only count) : _ -> return count
