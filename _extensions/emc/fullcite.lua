-- fullcite.lua
-- Replaces :::aside\n[@key]\n::: and ^[[@key]] with the full formatted
-- bibliography entry. Any aside or footnote whose sole content is a single
-- citation is expanded; mixed content (e.g. "See [@key] for details") is
-- left untouched so normal inline citations keep working.

local function get_cite_key(blocks)
  if #blocks ~= 1 then return nil end
  local block = blocks[1]
  if block.t ~= "Para" then return nil end
  local inlines = {}
  for _, inline in ipairs(block.content) do
    if inline.t ~= "Space" and inline.t ~= "SoftBreak" then
      table.insert(inlines, inline)
    end
  end
  if #inlines ~= 1 then return nil end
  local inline = inlines[1]
  if inline.t ~= "Cite" then return nil end
  if #inline.citations ~= 1 then return nil end
  return inline.citations[1].id
end

-- citeproc stores the formatted entry as RawInline HTML inside a Para,
-- so we convert to HTML and extract the csl-right-inline content.
local function extract_ref_content(entry_blocks)
  local html = pandoc.write(pandoc.Pandoc(entry_blocks), "html")

  -- Try to extract just the csl-right-inline part (strips the number prefix)
  local right = html:match('csl%-right%-inline">(.-)</div>')
  if right and right:match('%S') then
    return {pandoc.RawBlock("html", right)}
  end

  -- No csl-right-inline found; return everything stripped of csl-left-margin
  html = html:gsub('<div class="csl%-left%-margin">.-</div>%s*', '')
  return {pandoc.RawBlock("html", html)}
end

function Pandoc(doc)
  if not pandoc.utils.citeproc then return nil end

  local processed = pandoc.utils.citeproc(doc)

  local refs = {}
  for _, block in ipairs(processed.blocks) do
    if block.t == "Div" and block.identifier == "refs" then
      for _, entry in ipairs(block.content) do
        if entry.t == "Div" then
          local key = entry.identifier:match("^ref%-(.+)$")
          if key then
            refs[key] = extract_ref_content(entry.content)
          end
        end
      end
      break
    end
  end

  if next(refs) == nil then return nil end

  return doc:walk({
    Div = function(div)
      if div.classes:includes("aside") then
        local key = get_cite_key(div.content)
        if key and refs[key] then
          div.content = refs[key]
          return div
        end
      end
    end,
    Note = function(note)
      local key = get_cite_key(note.content)
      if key and refs[key] then
        return pandoc.Note(refs[key])
      end
    end,
  })
end
