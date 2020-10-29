module Main where

import Lib
import Crypto.Hash
import Data.ByteString (ByteString, empty)
import System.IO (openFile, hClose, IOMode( ReadMode ))
import qualified Data.ByteString (getLine, hGetContents)

exampleHashWith :: ByteString -> IO ()
exampleHashWith msg = do
    putStrLn $ "  sha1(" ++ show msg ++ ") = " ++ show (hashWith SHA1   msg)
    putStrLn $ "sha256(" ++ show msg ++ ") = " ++ show (hashWith SHA256 msg)

main :: IO ()
main = do
    --msg <- empty :: ByteString
    --msg <- Data.ByteString.getLine
    handle <- openFile "package.yaml" ReadMode
    msg <- Data.ByteString.hGetContents handle
    hClose handle
    exampleAES256 msg
