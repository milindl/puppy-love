{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ExtendedDefaultRules #-}

module Lib
    ( mongoRun
    ) where

import Database.MongoDB    (Action, Document, Document, Value, access,
                            close, connect, delete, exclude, find,
                            host, insertMany, master, project, rest,
                            select, sort, (=:), readHostPort)
import Control.Monad.Trans (liftIO)

mongoRun :: String -> IO ()
mongoRun hostAddr = do
    pipe <- connect $ readHostPort hostAddr
    e <- access pipe master "puppy" run
    close pipe
    print e

run :: Action IO ()
run = do
    -- clearTeams
    -- _ <- insertTeams
    -- allTeams >>= printDocs "All Teams"
    -- nationalLeagueTeams >>= printDocs "National League Teams"
    -- newYorkTeams >>= printDocs "New York Teams"
    sortedTeams >>= printDocs "Sorted declares"

sortedTeams :: Action IO [Document]
sortedTeams = rest =<< find (select [] "declare") {sort = ["v" =: 1]}

-- clearTeams :: Action IO ()
-- clearTeams = delete (select [] "team")

-- insertTeams :: Action IO [Value]
-- insertTeams = insertMany "team" [
--     ["name" =: "Yankees",
--      "home" =: ["city" =: "New York", "state" =: "NY"],
--      "league" =: "American"],
--     ["name" =: "Mets",
--      "home" =: ["city" =: "New York", "state" =: "NY"],
--      "league" =: "National"],
--     ["name" =: "Phillies",
--      "home" =: ["city" =: "Philadelphia", "state" =: "PA"],
--      "league" =: "National"],
--     ["name" =: "Red Sox",
--      "home" =: ["city" =: "Boston", "state" =: "MA"],
--      "league" =: "American"] ]

-- allTeams :: Action IO [Document]
-- allTeams = rest =<< find (select [] "team") {sort = ["home.city" =: 1]}

-- nationalLeagueTeams :: Action IO [Document]
-- nationalLeagueTeams = rest =<< find (select ["league" =: "National"] "team")

-- newYorkTeams :: Action IO [Document]
-- newYorkTeams = rest =<< find (select ["home.state" =: "NY"] "team")
--   {project = ["name" =: 1, "league" =: 1]}

printDocs :: String -> [Document] -> Action IO ()
printDocs title docs = liftIO $ putStrLn title >>
  mapM_ (print . exclude ["_id"]) docs
