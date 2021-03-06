#  Eonil Overlay

Overlay content view presentation/dismission management controller.

[![Example](http://img.youtube.com/vi/P0Ip-lpKDms/0.jpg)](http://www.youtube.com/watch?v=P0Ip-lpKDms "OverlayExample")

```Swift

    private let overlay = Overlay()

    func presentContent1() {
        var s = OverlayState()
        s.container = containerView
        s.content = contentView1
        overlay.control(.render(s))
    }
```



What is This?
----------------
This does only one thing. Manages presentation and dismission of *overlay* information view.
This includes these features.

- Programmtical presentation/dismissoin by code command.
- Dismission by swipe down.
- Dismission by tapping filling background.
- Dismission by dragging longer.
- Presented overlay view can be dragged a little bit to provide draggable look and feel.
- (TODO) Event emission for each moment of presentation/dismission.

Nothing more. This library does not provide much configurable options. Instead, this does one thing very well.

Requirements
-----------------
- This is fully *Auto Layout* based. Manual layout scenario has not been considered.
- Your overlay content view must have solveable minimum size.
- Your overlay content view must be resizable.
  Dragging overlay can grow size, but not shrink.
  If overlay content is too big for container, it will be shrunken to fit in the container.
  It's your responsibility to design internals of content view to work properly for any expected sizes.

For your convenience, this controller checks for requirements and crashes with error message
in debug build at treaceable location. You can check and solve any issues if required. Release build
silences any errors and just does best efforts.

Caveats
----------
- Cross-transition is not actually color-blended. It's just cross alpha-blending, and may show some graphical
  glitch. I couldn't find how to perform proper color blending with resizing and moving `UIView`s. 

- Overlay controller retains any view objects as long as it needed. This including presented state and enqueued
  state.
  
- Overlay controller cannot handle container size changes if it happen in animation is running.

- Dismission by end-user interaction is automatic by default, but can be off by setting config.

- Device rotation is not handled properly. 

- Keyboard kicking in has not been addressed. This controller does not do anything with keyboard.
  You can deal with virtual keyboard on your way by resizing or translating container view.



Credit & License
--------------------
Use of this library is allowed under "MIT License".
Copyright(c) 2018 Eonil. All rights reserved.
