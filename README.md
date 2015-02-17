# EMPartialModalViewController

Presents modal view controllers in style, while the height is under your control!

![EMPartialModalViewController shot](https://github.com/codeisjoy/EMPartialModalViewController/blob/master/partial_modal.jpg)

EMPartialModalViewController is a UIViewController subclass which takes a root view controller and present it modally. The height of presented view control is completely controllable.

## Usage

Before using the view controller to show your modals it is necessary to set `View controller-based status bar appearance` in the `Info.plist` of application `NO`. It is needed to capture the status bar in screen snapshot when modal view controller is about to show.

Then just initialise an instance of `EMPartialModalViewController` with a root view controller which would be the content of your modal.

There is two way to initialise:

**1. Specify the height directly <br/> `init(rootViewController: UIViewController, contentHeight: CGFloat)`**

This way the root view controller will be shown with the given height.

	let content: UIViewController  = <…>
	let partialModal: EMPartialModalViewController = EMPartialModalViewController(rootViewController: content, contentHeight: <desirable_size>)

**2. Let’s present the view controller with its own height<br/> `init(rootViewController: UIViewController)`**

This way the root view controller will be shown with the height that its `view` already has.

	let content: UIViewController = <…>
	var frame: CGRect = content.view.frame
	frame.size.height = 200
	content.view.frame = frame
	…
	let partialModal: EMPartialModalViewController = EMPartialModalViewController(rootViewController: content)

When you are done with the initialising the modal view controller the only thing should be done is presenting. So, just present that as you do normaly:

	presentViewController(partialModal, animated: true, completion: nil)

In addition, you can set the property of `contentViewMaxHeight` to indicate the maximum height that the content could have. By default, it has been set `402`.

## Install

Simply add it as a submodule then import `EMPartialModalViewController` folder into your Xcode project.

	git submodule add https://github.com/codeisjoy/EMPartialModalViewController.git <your lib directory>

#### Known issues

- It is not suitable for iPad. Showing modals in iPad should be completely different.
- It does not support rotation. If rotation happen it may have strange and unpredictable behaviour. So, at the moment just lock your app to support portrait mode only.
- You can not set `false` for `animated` when you are about to presenting view controller. This causes app crash.

		presentViewController(partialModal, animated: false, completion: nil)