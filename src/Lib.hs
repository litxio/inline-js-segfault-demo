{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TemplateHaskell #-}

module Lib
    ( someFunc
    ) where

import Language.JavaScript.Inline as JS
import System.Directory
import System.FilePath
import Control.Exception

someFunc :: IO ()
someFunc = do
  -- cwd <- getCurrentDirectory
  -- let nodePath = cwd </> "node_modules"
  -- putStrLn $ "Setting nodeModules to "<>nodePath
  sess <- JS.newSession defaultConfig -- {nodeModules=Just nodePath}

  () <- eval sess [js| require('does-not-exist.js'); |] >>= evaluate
  pure ()
