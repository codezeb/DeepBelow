![Logo][Logo]

DeepBelow
=========

iTunes cover behind your desktop!

Whats this?
-----------

DeepBelow simply displays the cover of the actual playing song from iTunes *behind* every other window or desktop icon.
You can't imagine that? See the examples! :wink:

Examples
--------
![example1][example1]
![example2][example2]
![example3][example3]

Settings
--------

At the moment, there is no functional Preference Pane. :thumbsdown:  However, you can edit the raw settings file, which is located here:
`~/Library/Preferences/org.dyndns.digitalforest.DeepBelow.plist`. Simply open it up with Xcode. Have either a look into the code or into the following notes to understand the items in there:

|Key Name | Default Value | Description |
|---------|---------------|------------ |
|`alpha` | 0.7 (70%) | The Alpha value ( = opacity) of the window and cover. The lower this value, the more you see the wallpaper through. |
|`horizontal` | 1 | The horizontal position. 1 -> Left, 2 -> Center, 3 -> Right |
|`vertical` | 3 | The vertical position. 1 -> Top, 2 -> Center, 3 -> Bottom |
|`size` | 300 | The width and height in pixels. `300` gives a cover with 300px height and 300px width. |
|`spacing` | 50 | The spacing between window and screen border, in Pixels. Has no effect if `horizontal` and `vertical` are set to 2 (Center) |

Todo
----
* Create a PrefPane

[example1]:http://i.imgur.com/kVu1nkQ.png "Example1"
[example2]:http://i.imgur.com/2AaN4ft.png "Example2"
[example3]:http://i.imgur.com/ar9ULhm.png "Example3"
[logo]:http://i.imgur.com/lsRHhgY.png "DeepBelow Logo"
