local chapter

function Pandoc(doc)
  for k, v in pairs(PANDOC_STATE) do
  end
end

function Meta(meta)
  chapter = meta.chapter
  quarto.doc.add_html_dependency({
    name = "assignment-styles",
    version = "1.0.0",
    stylesheets = { "assignment.css" }
  })
end

function Div(el)
  if el.classes[1] == "question" then
    if el.attributes.label == nil then
      label = "ass-"
    else
      label = el.attributes.label
    end

    title = quarto.FloatRefTarget({
      type = "Vraag",
      content = "",
      identifier = label,
      caption_long = "",
      caption_short = "",
    })

    outer = quarto.Callout({
      icon = false,
      type = "note",
      appearance = "default",
      title=title,
      content = el,
      collapse = false,
    })
    return outer
  elseif el.classes[1] == "answer" then
    inner = quarto.Callout({ type = "caution", icon = false, collapse = true, title = "Antwoord", content = el })
    outer = pandoc.Div({ inner, class = "answer-wrapper" })
    local condition
    condition = { { "when-profile", "clean" } }
    return quarto.ConditionalBlock({ node = outer, behavior = "content-hidden", condition = condition })
  elseif el.classes[1] == "reading" then
    inner = quarto.Callout({ type = "note", icon = false, title = "Leesopdracht", content = el , collapse="false"})
    outer = pandoc.Div({ inner, class = "reading-wrapper" })
    return outer
  elseif el.classes[1] == "context" then
    if el.attributes.title == nil then
      title = "Context"
    else
      title = el.attributes.title
    end
    inner = quarto.Callout({ type = "tip", icon = false, collapse = false, title = title, content = el })
    outer = pandoc.Div({ inner, class = "context-wrapper" })
    return outer
  elseif el.classes[1] == "box" then
    title = quarto.FloatRefTarget({
      type = "Box",
      content = "",
      identifier = "box-" .. el.attributes.label,
      caption_long = el.attributes.title,
      caption_short = el.attributes.title
    })
    box = quarto.Callout({ icon = false, type = "tip", content = el, title = title, collapse = false })
    return box
  elseif el.classes[1] == "lecturer-comments" then
    local title_text = el.attributes.title or "Opmerking"
    comments = quarto.Callout({
      icon = false,
      type = "important",
      content = el, 
      title = title_text,
      collapse = false,
    })
    outer = pandoc.Div(comments)
    condition = { { "when-profile", "lecturer" } }
    return quarto.ConditionalBlock({ node = outer, behavior = "content-visible", condition = condition })
  end
end

return {
  { Pandoc = Pandoc },
  { Meta = Meta },
  { Div = Div }
}
