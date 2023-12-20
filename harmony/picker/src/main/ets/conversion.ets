export function stringToAlignment(alignment:string){
  switch (alignment) {
    case "center":
      return TextAlign.Center
    case "right":
      return TextAlign.End
    case "justified":
      return TextAlign.JUSTIFY
    default:
      return TextAlign.Start
  }
}

export function stringToFontStyle(style:string|undefined):FontStyle{
  if(style==="italic"){
    return FontStyle.Italic
  }
  return FontStyle.Normal;
}