# MarvelTest

Example of how to use Marvel API in a Swift project.

**IMPORTANT**: This project uses Cocoapods as the dependency manager, make sure you have it installed. After download or clone it, apply the following command in the directory of the project:

```
pod install 
```

and then open MarvelTest.xcworkspace file.

Customization
-------

You can change the value of two constants on code to change project's aspects.

**usePhotoFilter** on `CharactersListViewController`: If this constant value is true, the app just shows characters that have thumbnail (and it is not a placeholder image) in the list of characters.

**useParallax** on `CharactersListViewController`: If this constant value is true, the app displays the list of characters using a parallax effect in the characters Table View Cells.
