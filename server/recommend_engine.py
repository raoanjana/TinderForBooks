#!/usr/bin/env python
import bottlenose, os.path, time, json
from HTMLParser import HTMLParser
from urllib2 import HTTPError
# from urllib.error import HTTPError
import xml.etree.ElementTree as ET
import re

TAG_RE = re.compile(r'<[^>]+>')
# Load the AWS key information
f = open(os.path.dirname(os.path.realpath(__file__)) + "/keys/aws_keys.json")
configs = json.loads(f.read())

def error_handler(err):
    ex = err['exception']
    if isinstance(ex, HTTPError) and ex.code == 503:
        time.sleep(random.expovariate(0.1))
        return True

def setup_product_api():
    print("here")
    return bottlenose.Amazon(configs["aws_public_key"],
                             configs["aws_secret_key"],
                             configs["product_api_tag"],
                             ErrorHandler=error_handler,
                             MaxQPS=0.9)

def get_recommendations_from_asins(asins):
    productapi = setup_product_api()
    root = ET.fromstring(productapi.SimilarityLookup(ItemId=asins, ResponseGroup="Images,EditorialReview,ItemAttributes",SimilarityType="Random"))
    namespace = root.tag[root.tag.find("{"): root.tag.find("}")+1]
    item = root.find(namespace + "Items").find(namespace + "Item")

    books = list()

    for item in root.find(namespace + "Items").findall(namespace + "Item"):
        book = dict()
        asin_node = item.find(namespace + "ASIN")
        author_node = item.find(namespace + "ItemAttributes").find(namespace + "Author")
        isbn_node = item.find(namespace + "ItemAttributes").find(namespace + "ISBN")
        title_node = item.find(namespace + "ItemAttributes").find(namespace + "Title")
        image_node = item.find(namespace + "LargeImage")

        image_url = "None"
        if image_node is None:
            image_node = item.find(namespace + "MediumImage")
        if image_node is None:
            image_node = item.find(namespace + "SmallImage")

        if image_node is not None:
            image_url_node = image_node.find(namespace + "URL")
            if image_url_node is not None:
                # add the image url to the json
                image_url = image_url_node.text
            else:
                print ("~~~~CANT FIND IMAGE FOR PRODUCT", asin_node.text)
                continue

        description = "Not available"
        for child in item.findall(".//"+ namespace + "EditorialReview"):
            # this node should always exist, since if there was no content there would be no review
            review_node = child.find(namespace + "Content")
            review = ""
            if review_node is not None:
                review = review_node.text
            # I'm assuming that a longer editorial review will be better written / a synopsis of the product and its themes
            if ( len(review) > len(description) ):
                description = review

        # get rid of weird formatting in amazon reviews
        h = HTMLParser()
        description = h.unescape(description)
        description = remove_tags(description)

        # we dont want any errors so just skip bad xml responses
        if description is "Not available":
            continue
        if title_node is None:
            continue
        if isbn_node is None:
            continue
        if author_node is None:
            continue

        book["asin"] = asin_node.text
        book["isbn"] = isbn_node.text
        book["title"] = title_node.text
        book["description"] = description
        book["image_url"] = image_url
        book["author"] = author_node.text
        books.append(book)

        # print(asin_node.text, ":", isbn_node.text, "\n" + author_node.text, ":", title_node.text, "\n" + description, "\n" + image_url, "\n")

    return (json.dumps(books))

def remove_tags(text):
    return TAG_RE.sub('', text)

if __name__ == '__main__':
    print(get_recommendations_from_asins("0316066524"))










