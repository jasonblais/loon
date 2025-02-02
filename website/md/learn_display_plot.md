<script>
window.onload = function() {
    document.getElementById("learn_display_plot").className += " selected";
    setLearnUrl("display_plot");
}
</script>

[tclman_image]: https://www.tcl.tk/man/tcl/TkCmd/image.htm "Tcl image manual"

![](images/display_plot.png "loon scatterplot")

<R>
~~~
data(olive); attach(olive)
p <- l_plot(x=oleic, y=stearic, color=Area)
~~~
</R>

<Tcl>
~~~
source olive.tcl
set p [plot -x $oleic -y $stearic -color $Area -xlabel oleic -ylabel stearic]
~~~
</Tcl>



# Scatterplot


* Get the state names with

<R>
		states <- l_info_states(p)
		names(states)
</R>

<Tcl>
	    set states [$p info states]
		dict keys $states
</Tcl>

* Query a state, say `background`, as follows

<R>
	    p['background']
</R>

<Tcl>
	    $p cget -background
</Tcl>

* Change a state, say again `background` and `foreground`, as follows

<R>
	    p['background'] <- 'gray20'
		p['foreground'] <- 'gray90'

	alternatively, and more efficient if you modify more than one
    state, use
	
		l_configure(p, background='gray20', foreground='gray90')
</R>

<Tcl>
	    $p configure -background gray20 -foreground gray90
</Tcl>

* When creating a plot you may specify any state at plot creation

<R>
	    p1 <- l_plot(x=oleic, y=stearic, color=Area,
			background='gray20', foreground='gray90')
</R>

<Tcl>
	    set p1 [-x $oleic -y $stearic -color $Area -xlabel oleic -ylabel stearic\
			 -background gray20 -foreground gray90]
</Tcl>


* details on a state, say `background`, is easily had with

<R>
	    states <- l_info_states(p)
		states$background

	and a particular field
	
		states$background$description
		
</R>

<Tcl>
	    set states [$p info states]
		dict get $states background

	and a particular field

	    dict get $states background description
</Tcl>


# Good To Know

* The scatterplot display supports
  [layers](learn_<R>R</R><Tcl>Tcl</Tcl>_layer.html).


# Glyphs

The visual representation of a point can be changed for each point
separately with the `n` dimensional state `glyph`. The supported glyph
types are detailed in the following sections. <R> The `l_glyphs` demo
demonstrates all the glyph types.</R>


## Primitive Glyphs

The supported primitives are `circle`, `ocircle`, `ccircle`, `square`,
`osquare`, `csquare`, `triangle`, `otriangle`, `ctriangle`, `diamond`,
`odiamond` and `cdiamont`.

<R>

~~~
data(olive); attach(olive)
p <- l_plot(x=oleic, y=stearic, color=Area)

glyphmap <- list(
	'South-Apulia'='circle',
	'North-Apulia'='ocircle',
	'Inland-Sardinia'='square',
	'Coast-Sardinia'='osquare',
	'East-Liguria'='triangle',
	'West-Liguria'='otriangle',
	'Calabria'='diamond',
	'Sicily'='odiamond',
	'Umbria'='odiamond') ## NOTE

p['glyph'] <- unlist(glyphmap[as.character(Area)])
~~~

</R>

<Tcl>

~~~
source olive.tcl
set p [plot -x $oleic -y $stearic -color $Area\
	-xlabel oleic -ylabel stearic]

set glyphmap [dict create\
	South-Apulia circle\
	North-Apulia ocircle\
	Inland-Sardinia square\
	Coast-Sardinia osquare\
	East-Liguria triangle\
	West-Liguria otriangle\
	Calabria diamond\
	Sicily odiamond\
	Umbria odiamond]; ## NOTE

$p configure -glyph [lmap a $Area {dict get $glyphmap $a}]
~~~

</Tcl>

![](images/display_plot_glyphs_primitive.png "loon scatterplot primitive glyphs")

## n Dimensional Glyphs

The non-primitive glyphs require user specified data. Adding a glyph
type requires to specify the glyph data for each of the `n` points. If
`n` of the plot changes the glyph will be deleted.

Glyphs, like plots and layers, have states and support state
bindings. You can query and modify the glyph states, or add state
bindings to glyphs at run time as shown below.

### Text

Text glyphs are character strings for each point

<R>

~~~
gt <- l_glyph_add_text(p, text=as.character(Region))
p['glyph'] <- gt
~~~

</R>

<Tcl>

~~~
set gt [$p glyph add text -text $Region]
$p configure -glyph $gt
~~~

</Tcl>

![](images/display_plot_glyphs_text.png "text glyphs")




### Serialaxes

Serialaxes glyph show either a star or a parralel coordinate glyph for
each point.

<R>

~~~
gs <- l_glyph_add_serialaxes(p, data=olive[,-c(1,2)])
p['glyph'] <- gs
~~~

</R>

<Tcl>

~~~
## $olivedata does not contain Area and Region
set gs [$p glyph add serialaxes -data $olivedata]
$p configure -glyph $gs
~~~

</Tcl>


![](images/display_plot_glyphs_serialaxes.png "serialaxes glyphs: radial axes")

Change the glyph appearance as explained in
[Query and Modify Glyph States][]

<R>

~~~
l_configure(gs, axesLayout='parallel', showEnclosing=TRUE)
~~~

</R>

<Tcl>

~~~
$p glyph use $gs configure -axesLayout parallel -showEnclosing TRUE
~~~


</Tcl>

![](images/display_plot_glyphs_serialaxes_parallel.png "serialaxes glyphs: parallel coordinates")

Please also see the <a
href='learn_<R>R</R><Tcl>Tcl</Tcl>_display_serialaxes.html'>serialaxes
display</a> documentation for more information regarding working with
serialaxes.


### Pointranges

If every point has a point range associated you can visualize this
information with the pointrage glyph.

<R>

~~~
p1 <- l_plot(x=1:3, y=1:3, color=1:3)
gr <- l_glyph_add_pointrange(p1, ymin=c(0,1.5, 2.3),
	ymax=c(1.6,2.4,3.1), linewidth=1:3, showArea=FALSE)
p1['glyph'] <- gr
~~~

</R>

<Tcl>

~~~
set p1 [plot -x {1 2 3} -y {1 2 3} -color {1 2 3}]
set gr [$p1 glyph add pointrange -ymin {0 1.5 2.3}\
	-ymax {1.6 2.4 3.1} -linewidth {1 2 3} -showArea FALSE]
$p1 configure -glyph $gr
~~~

</Tcl>

![](images/display_plot_glyphs_pointrange.png "pointrange glyphs")


### Polygons

A polygon can be a useful point glyph to visualize arbitrary shapes
such as airplanes, animals and shapes that are not available in the
primitive glyph types (e.g. cross). The `l_glyphs` demo has an example
of polygon glyphs which we reuse here.

First we specify the coordinates of the polygons, note that it is your
responsibility to center them at `0` and to specify an appropriate
size. A good range for the polygon coordinates is from `-1` to `1`.

~~~
x_star <- 
    c(-0.000864304235090734, 0.292999135695765, 0.949870354364736, 
      0.474503025064823, 0.586862575626621, -0.000864304235090734, 
      -0.586430423509075, -0.474070872947277, -0.949438202247191,
      -0.29256698357822)
y_star <-
    c(-1, -0.403630077787381, -0.308556611927398, 0.153846153846154, 
      0.808556611927398, 0.499567847882455, 0.808556611927398,
      0.153846153846154, -0.308556611927398, -0.403630077787381)
x_cross <- 
    c(-0.258931143762604, -0.258931143762604, -0.950374531835206, 
      -0.950374531835206, -0.258931143762604, -0.258931143762604,
      0.259651397291847, 0.259651397291847, 0.948934024776722,
      0.948934024776722, 0.259651397291847, 0.259651397291847)
y_cross <-
    c(-0.950374531835206, -0.258931143762604, -0.258931143762604, 
      0.259651397291847, 0.259651397291847, 0.948934024776722,
      0.948934024776722, 0.259651397291847, 0.259651397291847,
      -0.258931143762604, -0.258931143762604, -0.950374531835206)
x_hexagon <-
    c(0.773552290406223, 0, -0.773552290406223, -0.773552290406223, 
      0, 0.773552290406223)
y_hexagon <- 
    c(0.446917314894843, 0.894194756554307, 0.446917314894843,
      -0.447637568424085, -0.892754249495822, -0.447637568424085)
~~~

Then you can use those polygon coordinates to specify polygon glyphs
as follows

~~~
p <- l_plot(1:3, 1:3)

gl <- l_glyph_add_polygon(p, x = list(x_star, x_cross, x_hexagon),
                          y = list(y_star, y_cross, y_hexagon))

p['glyph'] <- gl
~~~


![](images/display_plot_glyphs_polygon.png "polygon glyphs")


### Images

**Note that image glyphs work well on Linux and OSX but not Windows!**
  Also, image glyphs rely on a `Tcl` procedure `image_scale` for image
  resizing. The `loon` package comes with a `image_scale` procedure
  that is pure `Tcl` code. To improve the image resizing speed it is
  possible to install the
  [ImageScale Tcl extension](https://github.com/waddella/tclImageScale
  "fast image resizing Tcl extension"). `loon` will check when it is
  loaded whether the 'ImageScale' package is installed and will use
  the faster procedure (also in `R`).


We fist start by creating the images and then show how to load images
form files.

<R>

~~~
img1 <- as.character(tkimage.create('photo', width=30, height=20))
tcl(img1, 'put', 'blue', '-to', 0, 0, 30, 20)
tcl(img1, 'put', 'yellow', '-to', 0, 6, 30, 11)
img2 <- as.character(tkimage.create('photo', width=80, height=80))
tcl(img2, 'put', 'red', '-to', 0, 0, 80, 80)
tcl(img2, 'put', 'green', '-to', 30, 30, 60, 60)
img3 <- as.character(tkimage.create('photo', width=60, height=100))
tcl(img3, 'put', 'orange', '-to', 0, 0, 60, 100)
tcl(img3, 'put', 'black', '-to', 40, 0, 50, 80)
~~~

</R>


<Tcl>

~~~{.tcl}
set img1 [image create photo -width 30 -height 20]
$img1 put blue -to 0 0 30 20; $img1 put yellow -to 0 6 30 11
set img2 [image create photo -width 80 -height 80]
$img2 put red -to 0 0 80 80; $img2 put green -to 30 30 60 60
set img3 [image create photo -width 60 -height 100]
$img3 put orange -to 0 0 60 100; $img3 put black -to 40 0 50 80
~~~

</Tcl>

Note that the images above have different sizes. The `loon`
scatterplot will resize the images (i.e. all glyph types) such that
their areas are proportional to their associated point sizes.

The images are added 

<R>

~~~
p <- l_plot(x=c(1,2,3), y=c(3,1,2),
	color=c('green','yellow','blue'), size=c(4,3,7))

gi <- l_glyph_add_image(p, images=c(img1,img2,img3), label="Abstract Art")

p['glyph'] <- gi
~~~

</R>

<Tcl>

~~~
set p [plot -x {1 2 3} -y {3 1 2}\
	-color {green yellow blue} -size {4 3 7}]

set gi [$p glyph add image -images [list $img1 $img2 $img3]\
	-label "Abstract Art"]

$p configure -glyph $gi
~~~

</Tcl>

![](images/display_plot_glyphs_image1.png "image glyphs")



<R>


#### Load Images

Images must be in the standard `tcl` [`image`][tclman_image]
format. Hence, you may read the [`image` manual][tclman_image] to get
a deeper understanding of creating, deleting, and querying images in
`tcl`.

We do, however, provide two functions that simplify importing images
from a set of files (jpg, png, bmp, etc.), and from an array with
greyscale image information in its rows or columns,
i.e. `l_image_import_files` and `l_image_import_array`, respectively.

If the images are stored in files in `jpg`, `png`, or `bmp` format you
can use our `l_image_import_files` function. The core `tcl`
interpreter does not know many image formats, but with `tcl`
[`Img` package](http://wiki.tcl.tk/1404) loaded you can import images
in the most common formats.

~~~
paths <- dir('path-to-folder-with-images', '*.png', full.names=TRUE)
imgs <- l_image_import_files(paths)
~~~

The `tcl` interpreter handles the image data internally and makes the
image objects accessible via handles named `image1`, `image2` and so
on. The `imgs` object from above is hence a vector with the image
object names. You can see the images in our image viewer as follows

~~~
l_imageviewer(imgs)
~~~

To add the images to a plot widget

~~~
l_glyph_add_image(p, images=imgs, label="faces")
~~~

To see working examples, take look at one of the following `loon`
package demos: `l_ng_images_faces`, `l_ng_images_frey_LLE`, or
`l_ng_images_frey_isomap`. For example,

~~~
demo('l_ng_images_faces')
~~~

![](images/display_plot_glyphs_image2.png "image glyphs")


It is possible to
[fill pictures pixel by pixel or row by row](http://wiki.tcl.tk/643)
as follows

~~~
library(tcltk); tt <- tktoplevel(); can <- tkcanvas(tt); tkpack(can)
pic <- tkimage.create('photo', width=20, height=30)
tkcreate(can, 'image', 50, 50, image=pic)
tcl(pic, 'put', 'yellow', '-to', 0, 0, 20, 30) # fill complete image
tcl(pic, 'put', 'red', '-to', 10, 15) # one pixel
# and row by row
.Tcl(paste(pic, 'put [list [lrepeat 16 blue] [lrepeat 16 green]] -to 0 17'))
~~~

![](images/display_plot_glyphs_image3.png "image pixel by pixel")

</R>

### Query and Modify Glyph States

The non-primitive glyphs (or n dimensional glyphs) have states. To
demonstrate how to work with glyph states we take the text glyph
example from above again:

<R>

~~~
data(olive); attach(olive)
p <- l_plot(x=oleic, y=stearic, color=Area)

gt <- l_glyph_add_text(p, text=as.character(Region))
p['glyph'] <- gt
~~~

</R>


<Tcl>

~~~
source olive.tcl
set p [plot -x $oleic -y $stearic -color $Area -xlabel oleic -ylabel stearic]

set gt [$p glyph add text -text $Region]
$p configure -glyph $gt
~~~

</Tcl>

![](images/display_plot_glyphs_text.png "text glyphs")

The procedure to list and get information about them is similar as
outlined in the <a
href=''learn_<R>R</R><Tcl>Tcl</Tcl>_states.html'>states
section</a>. For example get the state names of a glyph with

<R>
~~~
gtstates <- l_info_states(gt)
names(gtstates)
~~~

</R>

<Tcl>

~~~
set gtstates [$p glyph use $gt info states]
dict keys $gtstates
~~~

</Tcl>


Then to query a state, say `text`, use


<R>

~~~
gt['text']
~~~

</R>


And to modify a state

<R>

~~~
gt['text'] <- as.character(Area)
~~~

or, especially if you want to configure multiple states, you can use

~~~
l_configure(gt, text=as.character(Area))
~~~

</R>

<Tcl>

~~~
$p glyph use $gt configure -text $Area
~~~

</Tcl>

![](images/display_plot_glyphs_text_modify.png "text glyphs")





### Relabel, List, and Deleting Glyphs

Glyph labels are used in the plot and glyph inspector. You can specify
the glyph labels when creating the glyphs:

<R>

~~~
data(olive); attach(olive)
p <- l_plot(x=oleic, y=stearic, color=Area)

gt <- l_glyph_add_text(p, text=as.character(Region), label='Region')
p['glyph'] <- gt
~~~

</R>


<Tcl>

~~~
source olive.tcl
set p [plot -x $oleic -y $stearic -color $Area -xlabel oleic -ylabel stearic]

set gt [$p glyph add text -text $Region -label Region]
$p configure -glyph $gt
~~~

</Tcl>


or you may relabel once the glyphs already exist


<R>

~~~
l_glyph_relabel(p, id=gt, label='Region String')
~~~

</R>

<Tcl>

~~~
$p glyph relabel $gt "Region String"
~~~

</Tcl>

Note, that the `label` is part of the glyph collection and not the
glyph states.


To get all glyph ids with for a plot

<R>

~~~
l_glyph_ids(p)
~~~

</R>

<Tcl>

~~~
$p glyph ids
~~~

</Tcl>


To delete a glyph use

<R>

~~~
l_glyph_delete(p, id=gt)
~~~

</R>

<Tcl>

~~~
$p glyph delete $gt
~~~

</Tcl>

When deleting a glyph every point that was displayed as that glyph
will be switched to `circle`.
