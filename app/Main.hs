module Main where

import Lib
import Crypto.Hash
import Crypto.Cipher.AES (AES256)
import System.Directory (listDirectory)
import Data.ByteString (ByteString, empty)
import System.IO (withFile, openFile, hClose, IOMode( ReadMode ))
import qualified Data.ByteString (getLine, hGetContents, writeFile)

getContent :: String -> IO ByteString
-- use withBinaryFile for images?
getContent file = withFile file ReadMode Data.ByteString.hGetContents

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
            file_list <- listDirectory "."
            mapM (\file -> do
                    msg <- getContent file
                    --let encrypted = encrypt secretKey initIV msg
                    case encrypt secretKey initIV msg of
                        Left err -> error $ show err
                        Right eMsg -> Data.ByteString.writeFile (file ++ ".enc") eMsg)
                 file_list

    -- filter file list to files ending in an image extension
    -- check if is file with doesFileExist
    --contents <- mapM getContent file_list
    --mapM exampleAES256 contents
