{-
  Copyright (c) Meta Platforms, Inc. and affiliates.
  All rights reserved.

  This source code is licensed under the BSD-style license found in the
  LICENSE file in the root directory of this source tree.
-}

module Glean.Glass.Base
  ( GleanDBName(..)
  , GleanPath(..)
  , SymbolRepoPath(..)
  , RepoMapping(..)
  ) where

import Data.Hashable
import qualified Data.Map as Map
import Data.String
import Data.Text (Text)

import qualified Glean.Glass.Types as Glass

-- | Type of glean dbs
newtype GleanDBName = GleanDBName { unGleanDBName :: Text }
  deriving (Eq, Ord, Show, Hashable)

instance IsString GleanDBName where fromString = GleanDBName . fromString

--
-- | A glean path for www is prefixed with www/
-- For all other repos, it is relative to the repo root.
--
newtype GleanPath = GleanPath { gleanPath :: Text }
  deriving Eq

--
-- | A path relative to the given repo root
--
data SymbolRepoPath = SymbolRepoPath
  { symbolRepo :: Glass.RepoName
  , symbolPath :: Glass.Path
  }
  deriving (Show, Eq)

newtype RepoMapping = RepoMapping
  { gleanIndices :: Map.Map Glass.RepoName [(GleanDBName, Glass.Language)]
    -- ^ Glean indexes and the language they index. This should be in a config
    --
    -- This is the set of Glean dbs that should implement codemarkup.*
    --
    -- Note: the order here determines the order of search/lookup
    -- if you have overlapping dbs , for file contents, the first in the order
    -- with a src.File fact will win.
    --
    -- If you add/remove a db, consider if it needs to be present in
    -- gleanRequiredIndices as well
  }
