module Main where

import Lib
import Crypto.Hash
import Crypto.Cipher.AES (AES256)
import System.Directory (listDirectory, doesFileExist)
import Data.ByteString (ByteString, empty)
import System.IO (withFile, openFile, hClose, IOMode( ReadMode ))
import qualified Data.ByteString (getLine, hGetContents, writeFile)

getContent :: String -> IO ByteString
-- use withBinaryFile for images?
getContent file = withFile file ReadMode Data.ByteString.hGetContents

-- TODO: Read a config file for input and output directories.
main :: IO [()]
main = do
    --secret_key <- getContent "sec.key"
    --initIV <- getContent "ivec.txt"
    secretKey <- genSecretKey (undefined :: AES256) 32
    mInitIV <- genRandomIV (undefined :: AES256)
    case mInitIV of
        Nothing -> error "Failed to generate and initialization vector."
        Just initIV -> do
            -- Get files in current directory
            -- TODO: check if is file with doesFileExist
            file_list <- listDirectory "."
            mapM (\file -> do
                exists <- doesFileExist file
                if exists then do
                 msg <- getContent file
                 case encrypt secretKey initIV msg of
                     Left err -> error $ show err
                     Right eMsg -> Data.ByteString.writeFile (file ++ ".enc") eMsg
                else return ())
                file_list
