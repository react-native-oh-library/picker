#include "Props.h"
#include <react/renderer/core/PropsParserContext.h>
#include <react/renderer/core/propsConversions.h>

namespace facebook {
namespace react {

RNCHarmonyPickerProps::RNCHarmonyPickerProps(
    const PropsParserContext &context,
    const RNCHarmonyPickerProps &sourceProps,
    const RawProps &rawProps): ViewProps(context, sourceProps, rawProps),
    
    items(convertRawProp(context, rawProps, "items", sourceProps.items, {})),
    selectedIndex(convertRawProp(context, rawProps, "selectedIndex", sourceProps.selectedIndex, {0})),
    selectionColor(convertRawProp(context, rawProps,"selectionColor",sourceProps.selectionColor,{})),
    color(convertRawProp(context, rawProps, "color", sourceProps.color,{})),
    textAlign(convertRawProp(context, rawProps, "textAlign", sourceProps.textAlign,{})),
    numberOfLines(convertRawProp(context, rawProps, "numberOfLines", sourceProps.numberOfLines,{})),
    fontSize(convertRawProp(context, rawProps, "fontSize", sourceProps.fontSize,{})),
    fontWeight(convertRawProp(context, rawProps, "fontWeight", sourceProps.fontWeight,{})),
    fontStyle(convertRawProp(context, rawProps, "fontStyle", sourceProps.fontStyle,{})),
    fontFamily(convertRawProp(context, rawProps, "fontFamily", sourceProps.fontFamily,{})),
    themeVariant(convertRawProp(context, rawProps, "themeVariant", sourceProps.themeVariant,
                                {toString(RNCHarmonyPickerThemeVariant::Light)})) {}

} // namespace react
} // namespace facebook
