module Main where

import Lib
import Crypto.Hash
import Crypto.Cipher.AES (AES256)
import Data.ByteString (ByteString, empty)
import System.Directory (listDirectory, doesFileExist)
import qualified Data.ByteString (hGetContents, hGetLine, writeFile)
import System.IO (withFile, openFile, hClose, hGetLine, IOMode( ReadMode ))

getContent :: String -> IO ByteString
-- use withBinaryFile for images?
getContent file = withFile file ReadMode Data.ByteString.hGetContents

-- Get the input and output files for reading and encrypting files
getConfig :: FilePath -> IO (String, String)
getConfig f = withFile f ReadMode $ \h -> do
    iPath <- hGetLine h
    oPath <- hGetLine h
    return (iPath, oPath)

toFilePath :: String -> String -> String
toFilePath path fname = path ++ "/" ++ fname ++ ".enc"

-- TODO: Read a config file for input and output directories.
main :: IO [()]
main = do
    --secret_key <- getContent "sec.key"
    --initIV <- getContent "ivec.txt"
    secretKey <- genSecretKey (undefined :: AES256) 32
    mInitIV <- genRandomIV (undefined :: AES256)
    (iPath, oPath) <- getConfig "enc.config"
    case mInitIV of
        Nothing -> error "Failed to generate and initialization vector."
        Just initIV -> do
            -- Get files in current directory
            file_list <- listDirectory "."
            mapM (\file -> do
                let filePath = toFilePath oPath file
                -- only if path is a file (not a directory)
                exists <- doesFileExist file
                if exists then do
                    msg <- getContent file
                    case encrypt secretKey initIV msg of
                        Left err -> error $ show err
                        Right eMsg -> Data.ByteString.writeFile (toFilePath oPath file) eMsg
                else return ())
                file_list
