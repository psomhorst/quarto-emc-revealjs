function Image(el)
  if not quarto.doc.is_format("revealjs") then
    el.attr.attributes["height"] = nil
    return el
  end
end
