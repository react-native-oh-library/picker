/**
 * MIT License
 *
 * Copyright (C) 2021 Huawei Device Co., Ltd.
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
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANT KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

#pragma once

#include <jsi/jsi.h> 
#include <react/renderer/components/view/ViewProps.h>
#include <react/renderer/core/PropsParserContext.h>
#include <react/renderer/core/propsConversions.h>
#include <react/renderer/graphics/Color.h>
#include <vector>
#include "folly/json.h"
#include <folly/dynamic.h>

namespace facebook {
namespace react {

struct RNCPickerItemsStruct {
  std::string label;
  std::string value;
  SharedColor textColor;
  std::string testID;
};

static inline void fromRawValue(const PropsParserContext& context, const RawValue &value, RNCPickerItemsStruct &result) {
  auto map = (butter::map<std::string, RawValue>)value;

  auto tmp_label = map.find("label");
  if (tmp_label != map.end()) {
    fromRawValue(context, tmp_label->second, result.label);
  }
  auto tmp_value = map.find("value");
  if (tmp_value != map.end()) {
    fromRawValue(context, tmp_value->second, result.value);
  }
  auto tmp_textColor = map.find("textColor");
  if (tmp_textColor != map.end()) {
    fromRawValue(context, tmp_textColor->second, result.textColor);
  }
  auto tmp_testID = map.find("testID");
  if (tmp_testID != map.end()) {
    fromRawValue(context, tmp_testID->second, result.testID);
  }
}

static inline std::string toString(const RNCPickerItemsStruct &value) {
  return "[Object RNCPickerItemsStruct]";
}

class JSI_EXPORT RNCPickerProps final : public ViewProps {
 public:
  RNCPickerProps() = default;
  RNCPickerProps(const PropsParserContext& context, const RNCPickerProps &sourceProps, const RawProps &rawProps);

#pragma mark - Props

  std::vector<RNCPickerItemsStruct> items{};
  int selectedIndex{0};
  SharedColor selectionColor{};
  SharedColor color{};
  std::string textAlign{};
  int numberOfLines{0};
  int fontSize{0};
  std::string fontWeight{};
  std::string fontStyle{};
  std::string fontFamily{};
  std::string testID{};
  std::string themeVariant{};
};

} // namespace react
} // namespace facebook