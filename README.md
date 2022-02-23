# Simple dart web views

Library for creating a single page application on dart. Not compatible with Flutter.
Based on the [simple_dart_web_widgets](https://github.com/ViktorZahar/simple_dart_web_widgets)

# Navigation

The application consists of a MainWindow with global components and a set of Views.

## MainWindow
On the main window there are global components - which are always displayed (for example, the navigation menu). And the display area of the changing View - display.

MainWindow can be configured as you like by adding the necessary global components to it.
The configuration is performed by overriding the configureMainWindow() method.
There are two configuration examples in the standard library: MainWindowWithNavPath and MainWindowWithNavPathTheme.

## Examples of global components for MainWindow
SimpleNavBar - Navigation menu.
SimplePathPanel - Displaying the logical path of the current View.

## Views
All views displayed on display are inherited from the View class.
View have single instance.


### Properties of View

d - a unique string (must not contain characters reserved for URLs)
caption is a human-readable short title of the View, according to which the purpose of this View is clear.

The View can be child, i.e. it cannot exist without the parent View
isChild - the designation of whether this View is child

params and parent are parsed from the url and passed before the View is shown.

Transitions between Views should be carried out by reference or by the openPath method.
You can get to the View by following a link like: #some_view?n=15
The child View can be accessed by a link like: #some_parent_view?n=15/some_child_view?name=Bob
According to the parameters in this path, all parent Views initialized one by one and the last child View that is displayed.

The logic of initializing the View by parameters should be in the init method.
 
## Switching themes
The switchTheme method is included in class MainWindow.
The theme file consists of the theme name and the ending _theme.css for example super_theme.css.
If the theme is not specified during initialization, the default theme is default_theme.css

## Error display
The MainWindow also includes an error display method - showError and showFatalError.
This is the basic version of error display - it is assumed that these methods will be overridden.