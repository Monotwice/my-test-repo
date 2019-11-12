library("xml2")


# Filename: intro_xpath.R (02/12/2016)
# ported to 'xml2' package in Oct 2019

# TO DO: introducing the xpath-syntax

# Author(s): Dr. Jannes Muenchow, Patrick Schratz

# CONTENTS-------------------------------------------------

# ATTACH PACKAGES AND DATA------------------------------------------------------

# attach packages
library("xml2")

# 1 XPATH-----------------------------------------------------------------------

# before we begin, let's have a look at:
browseURL("https://www.w3schools.com/xml/xpath_intro.asp")

# retrieve an XML-example
doc = read_xml("https://www.w3schools.com/xml/books.xml")
class(doc)
# find the root node
root <- xml_root(doc)
class(root)

# name of the root node
xml_name(root)

# get the nodes
# Reihenfolge: Root, children(node), attribute
children = xml_children(root)
children

# attributes of the root node's children
xml_attrs(children)

# navigating through a XML-document
xml_contents(children[2])

# retrieving the value of a single node (same as above)
xml_child(root, 2)

# selecting all title nodes with an attribute named 'lang'
# attributes are queried using "@"
xml_find_all(root, "//title[@lang]")

# Selecting all the title elements that have a "lang" attribute with a value of
# "en"
xml_find_all(root, '//title[@lang="en"]')

# Selects all the book elements of the bookstore element that have a price
# element with a value greater than 35.00
xml_find_all(root, '/bookstore/book[price>35.00]')

# Selects all the title elements of the book elements of the bookstore element
# that have a price element with a value greater than 35.00
xml_find_all(root, '/bookstore/book[price>35.00]/title')


#als Liste schreiben
xml2::as.list


#Jason

# Filename: dm_scraping.R (2017-11-13)
#
# Author(s): Jannes Muenchow, Patrick Schratz
#
# CONTENTS-------------------------------------------------
#
# 1 SCRAPE DM LOCATIONS---------------------------------------------------------

# 1.1 have a look at the page to scrape -----------------------------------------

browseURL("https://www.dm.de/filialfinder-c468710.html?q_storefinder=")
# again uses google maps and the output of google maps is used to define a
# bounding box which is used in the following GET-query

# typing 90403, Nuremberg, Germany into the query window gives you following
# GET command (can be found using the network developers mode in your
# browser)
# this is basically a bbox we can construct ourselves using the google map
# API

# 1.2 construct a URL and build a bounding box around your centroid -------------

# here, I use the centroid of a Jena PC but you have to find the centroid
# programmatically, of course
coords = data.frame(X = 11.59398, Y = 50.94939)


#URL wurde von irgendjemandem angefragt, muss man rausfinden, wie das gehen soll
url = paste0(
  "https://www.dm.de/cms/restws/stores/find?requestingCountry=DE&", 
  "countryCodes=DE%2CAT%2CBA%2CBG%2CSK%2CRS%2CHR%2CCZ%2CRO%2CSI%", 
  "2CHU%2CMK&mandantId=100", 
  "&bounds=", coords$Y - 0.5, 
  "%2C", coords$X - 0.5,
  "%7C", coords$Y + 0.5, 
  "%2C", coords$X + 0.5, 
  "&before=false&after=false&morningHour=9&eveningHour=18&_", 
  "=1479236790492") 

# 1.3 download the GET response (which is a JSON file)---------------------------

browseURL(url)
# PLEASE RUN THE FOLLOWING COMMAND ONLY ONCE, we don't want to be blocked by the
# API due to an excessive amount of GET queries!
out = jsonlite::fromJSON(url)

# hence, save your output
#komprimiertes Paket, anders als save file...

saveRDS(out, "homework/01-stores/data/dm_json.rds")

# to read in the output, use
out = readRDS("homework/01-stores/data/dm_json.rds")

# 1.4 extract the information from the json-file you need -----------------------

out$address

#Tipp Hausaufgabe: data frame erstmal in Vektor umwandeln
