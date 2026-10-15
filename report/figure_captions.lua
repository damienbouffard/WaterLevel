-- Pandoc filter for the PDF version of the report.
-- 1. An image paragraph followed by an italic paragraph starting with "Figure" becomes one
--    floating figure with that text as caption, so LaTeX can fill pages and keep captions attached.
-- 2. The References are set in a smaller font.

-- figure widths (default: full text width), to help figures fit next to the text
WIDTHS = {["1"] = "80%"}

local function is_image_para(b)
  return b.t == "Para" and #b.content == 1 and b.content[1].t == "Image"
end

local function is_caption_para(b)
  return b.t == "Para" and #b.content == 1 and b.content[1].t == "Emph"
    and pandoc.utils.stringify(b.content[1]):match("^Figure%s")
end

function Pandoc(doc)
  local out = pandoc.Blocks{}
  local blocks = doc.blocks
  local i = 1
  while i <= #blocks do
    local b = blocks[i]
    if is_image_para(b) and blocks[i + 1] and is_caption_para(blocks[i + 1]) then
      local img = b.content[1]
      local caption = blocks[i + 1].content[1].content
      local num = pandoc.utils.stringify(caption):match("^Figure%s+(%d+)")
      if WIDTHS[num] then img.attributes.width = WIDTHS[num] end
      out:insert(pandoc.Figure(pandoc.Plain{img}, {long = {pandoc.Plain(caption)}}))
      i = i + 2
    else
      if b.t == "Header" and b.level == 2 and pandoc.utils.stringify(b) == "References" then
        -- start the references on a new page unless at least a third of the page is left
        out:insert(pandoc.RawBlock("latex", "\\vspace{0pt plus 0.33\\textheight}\\penalty-200\\vspace{0pt plus -0.33\\textheight}"))
      end
      out:insert(b)
      if b.t == "Header" and b.level == 2 and pandoc.utils.stringify(b) == "References" then
        out:insert(pandoc.RawBlock("latex", "\\small"))
      end
      i = i + 1
    end
  end
  doc.blocks = out
  return doc
end

-- 3. Author with numbered affiliations under the title (from the "affiliations" metadata list).
function Meta(meta)
  if meta.affiliations and meta.author then
    local name = pandoc.utils.stringify(meta.author)
    local n = #meta.affiliations
    local marks, lines = {}, {}
    for k = 1, n do
      marks[#marks + 1] = tostring(k)
      lines[#lines + 1] = "{\\small\\textsuperscript{" .. k .. "}" .. pandoc.utils.stringify(meta.affiliations[k]) .. "}"
    end
    local tex = name .. "\\textsuperscript{" .. table.concat(marks, ",") .. "}\\\\[0.5em]" .. table.concat(lines, "\\\\")
    meta.author = pandoc.MetaInlines{pandoc.RawInline("latex", tex)}
  end
  return meta
end
