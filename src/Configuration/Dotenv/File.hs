-- |
-- Module      :  Configuration.Dotenv.File
-- Copyright   :  © 2015–2017 Stack Builders Inc.
-- License     :  MIT
--
-- Maintainer  :  Stack Builders <hackage@stackbuilders.com>
-- Stability   :  experimental
-- Portability :  portable
--
-- This module provides parsers for dotenv files.

module Configuration.Dotenv.File where

import Control.Monad (liftM)
import Control.Monad.IO.Class
import System.Directory
import Text.Megaparsec

import Configuration.Dotenv.Parser
import Configuration.Dotenv.Types

-- | @parseMaybeFile@ parses a @.env@ file.
-- If the file does not exist then it returns @Nothing@.
parseMaybeFile :: MonadIO m => FilePath -> m (Maybe [Variable])
parseMaybeFile path = liftIO $ do
  exist <- doesFileExist path
  if exist
    then Just `liftM` parseFile path
    else return Nothing

-- | @parseFile@ parses a .env.example file.
-- If the file does not exist then it fails.
parseFile :: MonadIO m => FilePath -> m [Variable]
parseFile path = liftIO $ do
  content <- readFile path
  case parse configParser path content of
    Left err   -> error $ "Failed to read file" ++ show err
    Right vars -> return vars
