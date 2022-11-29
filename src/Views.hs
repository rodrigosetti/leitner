{-# LANGUAGE OverloadedStrings #-}

module Views where

import Control.Monad (forM_)
import Data.Text (splitOn, strip)
import Question (Question (qAnswer, qId, qQuestion))
import Text.Blaze.Html (Html, stringValue, text, (!))
import Text.Blaze.Html5
  ( a,
    body,
    docTypeHtml,
    form,
    h2,
    head,
    input,
    li,
    p,
    title,
    ul,
  )
import Text.Blaze.Html5.Attributes
  ( action,
    href,
    method,
    type_,
    value,
  )
import Prelude hiding (head)

questionView :: Question -> Html
questionView question = docTypeHtml $ do
  head $ title "Question"
  body $ do
    h2 $ text $ qQuestion question
    p $ a ! href (stringValue $ "/answer/" ++ show (qId question)) $ "Answer"

answerView :: Question -> Html
answerView question = docTypeHtml $ do
  head $ title "Answer"
  body $ do
    h2 $ text $ qQuestion question
    ul $ forM_ (splitOn "; " $ qAnswer question) (li . text . strip)
    p $ do
      form ! method "POST" ! action (stringValue $ "/right/" ++ show (qId question)) $ do
        input ! type_ "submit" ! value "Got right"
      form ! method "POST" ! action (stringValue $ "/wrong/" ++ show (qId question)) $ do
        input ! type_ "submit" ! value "Got wrong"
      a ! href "/" $ "Skip"
