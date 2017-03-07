import lxml.html
import datetime
from datetime import timedelta
from lxml import etree
from urllib.request import urlopen
import sys
import codecs
import os.path

target_folder = "/var/www/html/ebedmenu"

def write(doc, pattern, dayoffset):
	print("Finding " + pattern)
	el = doc.xpath('.//h4[text()="' + pattern + '"]/..//div[@class="sppb-menu-text"]')
	text = etree.tostring(el[0],encoding='unicode', method="xml")
	menu = text.replace("<div class=\"sppb-menu-text\">","").replace("</div>","").replace("</p>","").replace('<p class="p1">',"").replace("<br/>","\n")
	
	day = datetime.datetime.today() + timedelta(days=dayoffset)
	filename = target_folder + "/dezsoba_" + day.strftime("%Y-%m-%d") + ".txt"
	
	with codecs.open(filename, 'w', encoding='utf8') as f:
		f.write(menu)


def check():
	data = urlopen('http://dezsoba.hu/hu/heti-menue').read();
	return data.decode('utf-8', 'ignore');


doc = lxml.html.document_fromstring(check())
write(doc, "Hétfő", 0)
write(doc, "Kedd", 1)
write(doc, "Szerda", 2)
write(doc, "Csütörtök", 3)
write(doc, "Péntek", 4)