module Question where

import Data.Text ( Text )
import Database.SQLite.Simple.FromRow ( field, FromRow(..) )

data Question = Question {qId :: Int, qQuestion :: Text, qAnswer :: Text, qBox :: Int}

instance FromRow Question where
  fromRow = Question <$> field <*> field <*> field <*> field
