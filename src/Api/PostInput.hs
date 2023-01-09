{-# LANGUAGE DataKinds #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TypeOperators #-}

module Api.PostInput where

import DB (execute)
import Database.PostgreSQL.Simple (Only (..))
import Database.PostgreSQL.Simple.SqlQQ (sql)
import Handler (Handler)
import Key (Key)
import Servant (JSON, NoContent (..), PostNoContent, ReqBody, (:>))

type PostInput = "input" :> ReqBody '[JSON] Key :> PostNoContent

postInput :: Key -> Handler NoContent
postInput key = do
  _ <-
    execute
      [sql|
        INSERT INTO submissions (input, count)
        VALUES (?, 1)
        ON CONFLICT (input)
        DO UPDATE
        SET count = submissions.count + 1
      |]
      (Only key)
  pure NoContent
