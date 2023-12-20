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

#pragma once
#include "RNOHCorePackage/ComponentBinders/ViewComponentNapiBinder.h"
#include "Props.h"

namespace rnoh {

class PickerNapiBinder : public ViewComponentNapiBinder {
public:
    napi_value createProps(napi_env env, facebook::react::ShadowView const shadowView) override {
        napi_value napiViewProps = ViewComponentNapiBinder::createProps(env, shadowView);
        auto propsObjBuilder = ArkJS(env).getObjectBuilder(napiViewProps);
        if (auto props = std::dynamic_pointer_cast<const facebook::react::RNCPickerProps>(shadowView.props)) {
            auto items = std::vector<napi_value>();
            auto itemsRaw = props->items;

            propsObjBuilder.addProperty("selectedIndex", props->selectedIndex)
                .addProperty("selectionColor", props->selectionColor)
                .addProperty("color", props->color)
                .addProperty("textAlign", props->textAlign)
                .addProperty("numberOfLines", props->numberOfLines)
                .addProperty("fontSize", props->fontSize)
                .addProperty("fontWeight", props->fontWeight)
                .addProperty("fontStyle", props->fontStyle)
                .addProperty("fontFamily", props->fontFamily)
                .addProperty("themeVariant", props->themeVariant);

            for (auto item : itemsRaw) {
                auto itemObjBuilder = ArkJS(env).createObjectBuilder();
                itemObjBuilder.addProperty("label", item.label)
                    .addProperty("value", item.value)
                    .addProperty("textColor", item.textColor);
                items.push_back(itemObjBuilder.build());
            }

            auto itemsArray = ArkJS(env).createArray(items);
            propsObjBuilder.addProperty("items", itemsArray);
            return propsObjBuilder.build();
        }
        return napiViewProps;
    };
};

} // namespace rnoh
