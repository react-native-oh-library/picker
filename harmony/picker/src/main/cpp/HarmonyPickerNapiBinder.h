 #pragma once
#include "RNOHCorePackage/ComponentBinders/ViewComponentNapiBinder.h"
#include "Props.h"

namespace rnoh {

class HarmonyPickerNapiBinder : public ViewComponentNapiBinder {
public:  
    
    napi_value createProps(napi_env env, facebook::react::ShadowView const shadowView) override {
        napi_value napiViewProps = ViewComponentNapiBinder::createProps(env, shadowView);
        auto propsObjBuilder = ArkJS(env).getObjectBuilder(napiViewProps);
        if(auto props = std::dynamic_pointer_cast<const facebook::react::RNCHarmonyPickerProps>(shadowView.props)) {
            auto items = std::vector<napi_value>();
            auto itemsRaw = props->items;
            
            propsObjBuilder  
                .addProperty("selectedIndex",props->selectedIndex)
                .addProperty("selectionColor",props->selectionColor)
                .addProperty("color",props->color)
                .addProperty("textAlign",props->textAlign)
                .addProperty("numberOfLines",props->numberOfLines)
                .addProperty("fontSize",props->fontSize)
                .addProperty("fontWeight",props->fontWeight)
                .addProperty("fontStyle",props->fontStyle)
                .addProperty("fontFamily",props->fontFamily)
                .addProperty("themeVariant",props->themeVariant);
            
            for (auto item : itemsRaw) {
                auto itemObjBuilder = ArkJS(env).createObjectBuilder();
                itemObjBuilder
                    .addProperty("label", item.label)
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

