# Preview
![](https://raw.githubusercontent.com/lbischof/dashing-zenoss/master/preview.png)

# Description
Widget for [Dashing](http://dashing.io/) that shows [Zenoss](http://www.zenoss.com/) events.

# Dependencies
```
aplay: Plays notification on new event
zenity: Shows dialog if Zenoss is not reachable
```

# Usage
To use this widget, copy `zenoss.html`, `zenoss.coffee`, and `zenoss.scss` into a `/widgets/zenoss` directory, and copy the `zenoss.rb` file into your `/jobs` folder. Also copy the notifaction.wav file into the `assets` folder.

Edit the Zenoss URL in the job and the basic authentication part to suit your needs.

To include the widget in a dashboard, add the following snippet to the dashboard layout file:
```html
<li data-row="1" data-col="1" data-sizex="4" data-sizey="1">
    <div data-id="zenoss" data-view="Zenoss" data-title="Zenoss"></div>
</li>
```
