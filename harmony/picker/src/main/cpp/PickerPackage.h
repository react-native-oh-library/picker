#pragma once

// This file was generated.

#include "RNOH/Package.h"
#include "RNCPickerComponentDescriptor.h"
#include "RNCPickerJSIBinder.h"

namespace rnoh {

class PickerEventEmitRequestHandler : public EventEmitRequestHandler {
public:
    void handleEvent(Context const &ctx) override {
        auto eventEmitter = ctx.shadowViewRegistry->getEventEmitter<facebook::react::EventEmitter>(ctx.tag);
        if (eventEmitter == nullptr) {
            return;
        }

        std::vector<std::string> supportedEventNames = {
            "change",
        };
        if (std::find(supportedEventNames.begin(), supportedEventNames.end(), ctx.eventName) !=
            supportedEventNames.end()) {
            eventEmitter->dispatchEvent(ctx.eventName, ArkJS(ctx.env).getDynamic(ctx.payload));
        }
    }
};

class PickerPackage : public Package {
public:
    PickerPackage(Package::Context ctx) : Package(ctx){};

    std::vector<facebook::react::ComponentDescriptorProvider> createComponentDescriptorProviders() override {
        return {
            facebook::react::concreteComponentDescriptorProvider<facebook::react::RNCPickerComponentDescriptor>(),
        };
    }

    ComponentJSIBinderByString createComponentJSIBinderByName() override {
        return {
            {"RNCPicker", std::make_shared<RNCPickerJSIBinder>()},
        };
    };

    EventEmitRequestHandlers createEventEmitRequestHandlers() override {
        return {
            std::make_shared<PickerEventEmitRequestHandler>(),
        };
    }
};

} // namespace rnoh
