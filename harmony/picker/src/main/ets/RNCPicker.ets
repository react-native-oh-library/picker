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

import {
  ColorValue,
  Descriptor, RNComponentContext, RNViewBase,
  ViewBaseProps,
  ViewDescriptorWrapperBase,
  ViewRawProps, } from '@rnoh/react-native-openharmony';
import { RNC } from "@rnoh/react-native-openharmony/generated/ts"
import { stringToAlignment, stringToFontStyle } from './conversion'
import Logger from './Logger'

const TAG: string = "[RNOH] RNCPicker"

/**
 * @deprecated Use RNCPicker.NAME instead
 */
export const PICKER_TYPE: string = "RNCPicker"

interface ItemType {
  label?: string
  value: string
}

export interface AutoLayoutViewState {}

export interface AutoLayoutViewRawProps extends ViewRawProps {
  enabled?: boolean;
  selectedIndex?: number;
  items?: ItemType[];
  color?: ColorValue;
  fontSize?: number;
  fontWeight?: FontWeight;
  fontStyle?: string;
  fontFamily?: string;
  selectionColor?: ColorValue;
}

export const FLASH_LIST_TYPE: string = "AutoLayoutView";

export type AutoLayoutViewDescriptor = Descriptor<"AutoLayoutView", ViewBaseProps, AutoLayoutViewState, AutoLayoutViewRawProps>

class AutoLayoutViewDescriptorWrapper extends ViewDescriptorWrapperBase<"AutoLayoutView", ViewBaseProps, AutoLayoutViewState, AutoLayoutViewRawProps> {
}

@Component
export struct RNCPicker {
  public static readonly NAME = RNC.RNCPicker.NAME
  ctx!: RNComponentContext
  tag: number = 0
  @State descriptor: AutoLayoutViewDescriptor = Object() as AutoLayoutViewDescriptor;
  @State descriptorWrapper: AutoLayoutViewDescriptorWrapper | undefined = undefined;
  private eventEmitter: RNC.RNCPicker.EventEmitter | undefined = undefined
  private cleanUpCallbacks: (() => void)[] = []
  timer: number = 0
  changing: boolean = false;
  selectIndex: number = 0
  selectValue: string = ''
  @State enable: boolean = true;
  @State range: string[] = [] // 由label组成，label：Displayed value on the Picker Item
  @State selected: number = 0
  @State value: string | undefined = '' // Actual value on the Picker Item
  private valueMap: Map<string, string> = new Map()

  aboutToAppear() {
    this.eventEmitter = new RNC.RNCPicker.EventEmitter(this.ctx.rnInstance, this.tag);
    this.descriptor = this.ctx.descriptorRegistry.getDescriptor<AutoLayoutViewDescriptor>(this.tag);
    this.descriptorWrapper = new AutoLayoutViewDescriptorWrapper(this.descriptor);
    this.onDescriptorWrapperChange(this.descriptor);
    this.cleanUpCallbacks.push(this.ctx.descriptorRegistry.subscribeToDescriptorChanges(this.tag,
      (newDescriptor) => {
        this.onDescriptorWrapperChange(newDescriptor as AutoLayoutViewDescriptor);
      }
    ))
    this.cleanUpCallbacks.push(new RNC.RNCPicker.CommandReceiver(this.ctx.componentCommandReceiver,
      this.tag).subscribe("setNativeSelectedIndex", (argv) => {
      if (argv) {
        this.selected = argv[0] as number;
      }
    }))
  }

  private onDescriptorWrapperChange(newDescriptor: AutoLayoutViewDescriptor) {
    this.descriptor = newDescriptor;
    this.descriptorWrapper = new AutoLayoutViewDescriptorWrapper(this.descriptor);
    this.range = this.getRange()
    this.valueMap = this.getValueMap()
    this.enable = this.descriptor.rawProps.enabled ?? true;
    if (this.selected !== this.descriptor.rawProps.selectedIndex) {
      this.selected = this.descriptor.rawProps.selectedIndex ?? 0;
    }
  }

  aboutToDisappear() {
    this.cleanUpCallbacks.forEach(cb => cb())
  }

  getRange(): string[] {
    let items = this.descriptor.rawProps.items ?? [];
    let range: string[] = [];
    let items_num: number = items.length ?? 0
    for (let i = 0; i < items_num; i++) {
      range.push(items[i].label ?? '')
    }
    Logger.debug(TAG, `range: ${range}`)
    return range
  }

  getValueMap(): Map<string, string> {
    let items = this.descriptor.rawProps.items ?? [];
    let valueMap: Map<string, string> = new Map()
    let items_num: number = items.length ? items.length : 0
    for (let i = 0; i < items_num; i++) {
      valueMap.set(items[i].label ?? '', items[i].value ?? '')
    }
    Logger.debug(TAG, `valueMap: ${JSON.stringify(valueMap)}`)
    return valueMap
  }

  getTextStyle(): PickerTextStyle {
    return {
      color: this.descriptor.rawProps.color ? this.descriptor.rawProps.color.toString() : "#ff182431",
      font: {
        size: this.descriptor.rawProps.fontSize ?? 16,
        weight: this.descriptor.rawProps.fontWeight ?? FontWeight.Normal,
        style: this.descriptor.rawProps.fontStyle ? stringToFontStyle(this.descriptor.rawProps.fontStyle) :
        FontStyle.Normal,
        family: this.descriptor.rawProps.fontFamily ?? 'Arial'
      },
    };
  }

  getSelectionStyle(): PickerTextStyle {
    return {
      color: this.descriptor.rawProps.selectionColor ? this.descriptor.rawProps.selectionColor.toString() :
        '#ff007dff',
      font: {
        size: this.descriptor.rawProps.fontSize ?? 16,
        weight: this.descriptor.rawProps.fontWeight ?? FontWeight.Normal,
        style: this.descriptor.rawProps.fontStyle ? stringToFontStyle(this.descriptor.rawProps.fontStyle) :
        FontStyle.Normal,
        family: this.descriptor.rawProps.fontFamily ?? 'Arial'
      },
    };
  }

  _onChange(value: string | string[], index: number | number[] ): void {
    const newValue : string = (typeof value === 'string' ? this.valueMap.get(value) : this.valueMap.get(value[0])) || '';
    const newIndex : number = typeof index === 'number' ? index : index[0];
    this.selectIndex = newIndex
    this.selectValue = newValue
    this.backData()
  }
  backData() {
    if (!this.changing) {
      clearTimeout(this.timer)
      this.timer = setTimeout(() => {
        this.eventEmitter!.emit("change", {
          newValue: this.selectValue,
          newIndex: this.selectIndex
        })
      }, 500)
    }
  }
  _onTouch(event: TouchEvent) {
    if (event.type === TouchType.Down) {
      this.changing = true;
    }
    if (event.type === TouchType.Up) {
      this.changing = false;
      this.backData()
    }
  }

  build() {
    RNViewBase({ ctx: this.ctx, tag: this.tag }) {
      TextPicker({
        range: this.range, // 选择器的数据选择列表
        // selected: this.selected, // 设置默认选中项在数组中的索引值
        // value: this.value, // 设置默认选中项的值，优先级低于selected
      })// .defaultPickerItemHeight() // 设置Picker各选择项的高度
        .enabled(this.enable)
        .disappearTextStyle(this.getTextStyle())// 设置所有选项中最上和最下两个选项的文本颜色、字号、字体粗细
        .textStyle(this.getTextStyle())// 设置所有选项中除了最上、最下及选中项以外的文本颜色、字号、字体粗细
        .selectedTextStyle(this.getSelectionStyle())// 设置选中项的文本颜色、字号、字体粗细
        .selectedIndex(this.selected)// 设置默认选中项在数组中的索引值，优先级高于options中的选中值
        .canLoop(false)// 设置是否可循环滚动
        .onChange((value: string | string[], index: number | number[]) => this._onChange(value, index))
        .onTouch((event: TouchEvent) => this._onTouch(event))
        .width("100%")
        .height("100%")
    }
  }
}