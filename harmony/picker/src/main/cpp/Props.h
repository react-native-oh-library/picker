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

enum class RNCHarmonyPickerThemeVariant { Light, Dark };

inline void fromRawValue(const PropsParserContext &context, const RawValue &value,
                         RNCHarmonyPickerThemeVariant &result) {
    auto string = (std::string)value;
    if (string == "light") {
        result = RNCHarmonyPickerThemeVariant::Light;
        return;
    }
    if (string == "dark") {
        result = RNCHarmonyPickerThemeVariant::Dark;
        return;
    }
    abort();
}

inline std::string toString(const RNCHarmonyPickerThemeVariant &value) {
    switch (value) {
    case RNCHarmonyPickerThemeVariant::Light:
        return "light";
    case RNCHarmonyPickerThemeVariant::Dark:
        return "dark";
    }
}

struct RNCHarmonyPickerItemsStyleStruct {
    SharedColor textColor;
    std::string label;
    std::string value;
};

static inline void fromRawValue(const PropsParserContext &context, const RawValue &value, 
                                RNCHarmonyPickerItemsStyleStruct &result) {
    auto map = (butter::map<std::string, RawValue>)value;

    auto tmp_backgroundColor = map.find("backgroundColor");
    if (tmp_backgroundColor != map.end()) {
        fromRawValue(context, tmp_backgroundColor->second, result.textColor);
    }
    auto tmp_color = map.find("color");
    if (tmp_color != map.end()) {
        fromRawValue(context, tmp_color->second, result.label);
    }
    auto tmp_fontSize = map.find("fontSize");
    if (tmp_fontSize != map.end()) {
        fromRawValue(context, tmp_fontSize->second, result.value);
    }
}

static inline std::string toString(const RNCHarmonyPickerItemsStyleStruct &value) {
    return "[Object RNCHarmonyPickerItemsStyleStruct]"; 
}

struct RNCHarmonyPickerItemsStruct {
    SharedColor textColor;
    std::string label;
    std::string value;
};

static inline void fromRawValue(const PropsParserContext &context, const RawValue &value, 
                                RNCHarmonyPickerItemsStruct &result) {
    auto map = (butter::map<std::string, RawValue>)value;

    auto tmp_label = map.find("label");
    if (tmp_label != map.end()) {
        fromRawValue(context, tmp_label->second, result.label);
    }
    auto tmp_value = map.find("value");
    if (tmp_value != map.end()) {
        fromRawValue(context, tmp_value->second, result.value);
    }
    auto tmp_color = map.find("textColor");
    if (tmp_color != map.end()) {
        fromRawValue(context, tmp_color->second, result.textColor);
    }
}

static inline std::string toString(const RNCHarmonyPickerItemsStruct &value) {
    return "[Object RNCAndroidDropdownPickerItemsStruct]"; 
}

class JSI_EXPORT RNCHarmonyPickerProps final : public ViewProps {
public:
    RNCHarmonyPickerProps() = default;
    RNCHarmonyPickerProps(const PropsParserContext &context, const RNCHarmonyPickerProps &sourceProps, const RawProps &rawProps);

#pragma mark - Props 

    std::vector<RNCHarmonyPickerItemsStruct> items {};
    int selectedIndex{0};
    SharedColor selectionColor{};
    SharedColor color{};
    std::string textAlign;
    int numberOfLines{};
    int fontSize{};
    std::string fontWeight{};
    std::string fontStyle{};
    std::string fontFamily{};
    std::string testID{};
    std::string themeVariant{toString(RNCHarmonyPickerThemeVariant::Light)};
};

} // namespace react 
} // namespace facebook