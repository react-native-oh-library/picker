#include "RNOH/Package.h"
#include "ComponentDescriptor.h"
#include "HarmonyPickerJSIBinder.h"
#include "HarmonyPickerNapiBinder.h"
#include "HarmonyPickerEventEmitRequestHandler.h"

namespace rnoh {
    
class HarmonyPickerPackage : public Package {
public:
    HarmonyPickerPackage(Package::Context ctx) : Package(ctx) {}
    
    std::vector<facebook::react::ComponentDescriptorProvider> createComponentDescriptorProviders() override {
        return {facebook::react::concreteComponentDescriptorProvider<facebook::react::RNCHarmonyPickerComponentDescriptor>()};
    }
    
    ComponentNapiBinderByString createComponentNapiBinderByName() override {
        return{{"RNCHarmonyPicker", std::make_shared<HarmonyPickerNapiBinder>()}};
    };
    
    ComponentJSIBinderByString createComponentJSIBinderByName() override {
        return{{"RNCHarmonyPicker", std::make_shared<HarmonyPickerJSIBinder>()}};
    };
    
    EventEmitRequestHandlers createEventEmitRequestHandlers() override {
        return{std::make_shared<HarmonyPickerEventEmitRequestHandler>()};
    }
};
} //namespace rnoh