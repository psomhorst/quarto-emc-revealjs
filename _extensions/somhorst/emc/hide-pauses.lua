function Para(el)
  if not quarto.doc.is_format("revealjs") and
     pandoc.utils.stringify(el) == ". . ." then
    return {}
  end
end
