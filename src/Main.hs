{-# LANGUAGE OverloadedStrings #-}

module Main where

import Control.Monad.IO.Class (liftIO)
import Data.Text (Text)
import Database.SQLite.Simple
  ( Connection,
    Only (Only),
    close,
    execute,
    open,
    query,
    query_,
  )
import Network.Wai.Middleware.RequestLogger (logStdoutDev)
import Text.Blaze.Html.Renderer.Text (renderHtml)
import Views (answerView, questionView)
import Web.Scotty
  ( ScottyM,
    get,
    html,
    middleware,
    param,
    post,
    redirect,
    scotty,
  )

main :: IO ()
main = do
  db <- open "questions.db"
  scotty 8080 $ do
    middleware logStdoutDev
    home db >> answer db >> right db >> wrong db
  close db

home :: Connection -> ScottyM ()
home db = get "/" $ do
  [question] <- liftIO $ query_ db "SELECT * FROM questions WHERE box IN (SELECT MIN(box) FROM QUESTIONS) ORDER BY RANDOM() LIMIT 1"
  html $ renderHtml $ questionView question

answer :: Connection -> ScottyM ()
answer db = get "/answer/:id" $ do
  id_ <- param "id"
  [question] <- liftIO $ query db "SELECT * FROM questions WHERE id = ?" (Only (id_ :: Int))
  html $ renderHtml $ answerView question

right :: Connection -> ScottyM ()
right db = post "/right/:id" $ do
  id_ <- param "id"
  liftIO $ execute db "UPDATE questions SET box = box + 1 WHERE id = ?" (Only (id_ :: Int))
  redirect "/"

wrong :: Connection -> ScottyM ()
wrong db = post "/wrong/:id" $ do
  id_ <- param "id"
  liftIO $ execute db "UPDATE questions SET box = 1 WHERE id = ?" (Only (id_ :: Int))
  redirect "/"
