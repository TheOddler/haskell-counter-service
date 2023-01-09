{-# LANGUAGE GeneralizedNewtypeDeriving #-}

module Handler where

import Control.Monad.Catch (MonadThrow)
import Control.Monad.Reader (MonadIO, MonadReader, ReaderT (..))
import Data.Pool (Pool)
import Database.PostgreSQL.Simple (Connection)
import qualified Servant

-- Usually this would be `data ...` but in this case I only have one field
newtype Environment = Environment
  { dbConnectionPool :: Pool Connection
  }

newtype Handler a = Handler {runHandler :: ReaderT Environment Servant.Handler a}
  deriving (Functor, Applicative, Monad, MonadIO, MonadReader Environment, MonadThrow)

toServantHandler :: Environment -> Handler a -> Servant.Handler a
toServantHandler env handler = runReaderT (runHandler handler) env
