/**
 * MIT License
 *
 * Copyright (C) 2023 Huawei Device Co., Ltd.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

#include "Props.h"
#include <react/renderer/core/PropsParserContext.h>
#include <react/renderer/core/propsConversions.h>

namespace facebook {
namespace react {

RNCPickerProps::RNCPickerProps(
    const PropsParserContext &context,
    const RNCPickerProps &sourceProps,
    const RawProps &rawProps): ViewProps(context, sourceProps, rawProps),

    items(convertRawProp(context, rawProps, "items", sourceProps.items, {})),
    selectedIndex(convertRawProp(context, rawProps, "selectedIndex", sourceProps.selectedIndex, {0})),
    selectionColor(convertRawProp(context, rawProps, "selectionColor", sourceProps.selectionColor, {})),
    color(convertRawProp(context, rawProps, "color", sourceProps.color, {})),
    textAlign(convertRawProp(context, rawProps, "textAlign", sourceProps.textAlign, {})),
    numberOfLines(convertRawProp(context, rawProps, "numberOfLines", sourceProps.numberOfLines, {0})),
    fontSize(convertRawProp(context, rawProps, "fontSize", sourceProps.fontSize, {0})),
    fontWeight(convertRawProp(context, rawProps, "fontWeight", sourceProps.fontWeight, {})),
    fontStyle(convertRawProp(context, rawProps, "fontStyle", sourceProps.fontStyle, {})),
    fontFamily(convertRawProp(context, rawProps, "fontFamily", sourceProps.fontFamily, {})),
    testID(convertRawProp(context, rawProps, "testID", sourceProps.testID, {})),
    themeVariant(convertRawProp(context, rawProps, "themeVariant", sourceProps.themeVariant, {}))
      {}

} // namespace react
} // namespace facebook
