module Main where

import Lib
import Crypto.Hash
import System.Directory (listDirectory)
import Data.ByteString (ByteString, empty)
import System.IO (withFile, openFile, hClose, IOMode( ReadMode ))
import qualified Data.ByteString (getLine, hGetContents)

getContent :: String -> IO ByteString
-- use withBinaryFile for images?
getContent file = withFile file ReadMode Data.ByteString.hGetContents

main :: IO [()]
main = do
    file_list <- listDirectory "."
    --exampleAES256 <$> mapM getContent file_list
    -- check if is file with doesFileExist
    contents <- mapM getContent file_list
    mapM exampleAES256 contents
