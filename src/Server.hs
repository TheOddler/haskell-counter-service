{-# LANGUAGE TypeOperators #-}

module Server (main, application) where

import Api.GetQuery (GetQuery, getQuery)
import Api.PostInput (PostInput, postInput)
import DB (initConnectionPool, initDB)
import Database.PostgreSQL.Simple (defaultConnectInfo, postgreSQLConnectionString)
import Handler (Environment (..), toServantHandler)
import Network.Wai.Handler.Warp (run)
import Servant (Proxy (..), Server, hoistServer, serve, type (:<|>) ((:<|>)))
import Servant.Server (Application)

type Api = PostInput :<|> GetQuery

api :: Proxy Api
api = Proxy

server :: Environment -> Server Api
server env = hoistServer api (toServantHandler env) (postInput :<|> getQuery)

application :: Environment -> Application
application env = serve api $ server env

main :: IO ()
main = do
  putStrLn "Initializing..."

  let connStr = postgreSQLConnectionString defaultConnectInfo
  conns <- initConnectionPool connStr
  initDB connStr

  let env =
        Environment
          { dbConnectionPool = conns
          }

  putStrLn "Server running..."
  run 9000 $ application env
