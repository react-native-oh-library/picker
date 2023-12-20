import * as React from 'react';
import {TextStyle, StyleProp, ViewProps} from 'react-native';
import {ItemValue} from '@react-native-picker/picker/typings/Picker';

export interface PickerHarmonyItemProps {
  label?: string;
  value?: number | string;
  color?: string;
  testID?: string;
}

declare class PickerHarmonyItem extends React.Component<PickerHarmonyItemProps, {}> {}

export interface PickerHarmonyProps extends ViewProps {
	itemStyle?: StyleProp<TextStyle>;
	style?: StyleProp<TextStyle>;
	onChange?: React.SyntheticEvent<{itemValue: ItemValue, itemIndex: number}>;
	onValueChange?: (itemValue: ItemValue, itemIndex: number) => void;
	selectedValue?: ItemValue;
	testID?: string;
	numberOfLines?: number;
	themeVariant ?: string;
}

declare class PickerHarmony extends React.Component<PickerHarmonyProps, {}> {
  static Item: typeof PickerHarmonyItem;
}

export {PickerHarmony};
