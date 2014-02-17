module Main where

import Control.Monad (forM_)
import Data.Unamb
import Data.Time.Clock (getCurrentTime, diffUTCTime)
import Control.Concurrent
import Control.Concurrent.MVar

undefinedList :: Int -> ()
undefinedList n = unambs (replicate n undefined ++ [()] ++ replicate n undefined)

runsIn :: Double -> a -> IO Bool
runsIn t x = do
    fini <- newEmptyMVar
    tid <- forkIO $ do
        t0 <- getCurrentTime
        return $! x
        t1 <- getCurrentTime
        putMVar fini $ realToFrac (t1 `diffUTCTime` t0) <= t
    threadDelay (floor (10^6 * t))
    killThread tid
    v <- tryTakeMVar fini
    return $ maybe False id v

hard :: Int -> Int
hard n = unambs (replicate n (last [1..]) ++ [0] ++ replicate n (last [1..]))

tests = [
    ("undefinedList 100", runsIn 1 (undefinedList 100)),
    ("last [1..] `unamb` 0", runsIn 1 (last [1..] `unamb` 0)),
    ("0 `unamb` last [1..]", runsIn 1 (last [1..] `unamb` 0)),
    ("hard 1", runsIn 1 (hard 1)),
    ("hard 10", runsIn 5 (hard 10)) ]

main = do
    forM_ tests $ \(name, test) -> do
        putStrLn . ((name ++ ": ") ++) . show =<< test
