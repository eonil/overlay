#  Eonil Overlay

Overlay content view presentation/dismission management controller.

[![Example](http://img.youtube.com/vi/P0Ip-lpKDms/0.jpg)](http://www.youtube.com/watch?v=P0Ip-lpKDms "OverlayExample")

What is This?
----------------
This does only one thing. Manages presentation and dismission of *overlay* information view.
This includes these features.

- Programmtical presentation/dismissoin by code command.
- Dismission by swipe down.
- Dismission by tapping filling background.
- Dismission by dragging longer.
- Presented overlay view can be dragged a little bit to provide swipe look and feel.
- Event emission for each moments of presentation/dismission.

Nothing more. This library does not provide much configurable options. Instead, this does one thing very well.

Requirements
-----------------
- This is fully *Auto Layout* based. Manual layout scenario has not been considered.
- Your overlay content view must have solveable minimum size.
- Your overlay content view must be resizable. Dragging overlay can grow size, but not shrink.

For your convenience, this controller checks for requirements and crashes with error message
in debug build at treaceable location. You can check and solve any issues if required. Release build
silences any errors and just does best efforts.

Caveats
----------
- Cross-transition is not actually color-blended. It's just cross-alpha blending, and may show some graphical
  glitch. I couldn't find how to perform proper color blending with resizing and moving `UIView`s. 

- Overlay controller retains any view objects as long as it needed. This including presented state and enqueued
  state.
  
- Overlay controller cannot handle container size changes if it happen in animation is running.

- Dismission by end-user interaction is automatic by default, but can be off by setting config.

- Device rotation is not handled properly. 

- Keyboard kicking in has not been addressed.



Credit & License
--------------------
Use of this library is allowed under "MIT License".
Copyright(c) 2018 Eonil. All rights reserved.
