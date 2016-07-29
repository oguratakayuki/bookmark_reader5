# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

class Folder
  constructor: (elem) ->
    @element = elem
    @bookmarks = {}
    @title = ->
      $(@element).data('title')
    @id = ->
      $(@element).data('id')
    @is_root = ->
      $(@element).data('isroot')
    @child_ids = ->
      $(@element).data('child-ids')
    @has_child = ->
      $(@element).data('child-ids')
    @nests = ->
      $(@element).data('nests')
    @add_bookmark = (bookmark) ->
      unless bookmark.id() in @bookmarks
        @bookmarks[bookmark.id()] = bookmark
    @bookmark_count = () ->
      #連想配列の要素数
      Object.keys(@bookmarks).length
    @show = ->
      $(@element).show()


class Bookmark
  constructor: (elem) ->
    @element = elem
    @bind_events  = ->
      $(@element).click (e) ->
        e.preventDefault()
        e.stopPropagation()
    @title = ->
      $(@element).data('title')
    @id = ->
      $(@element).data('id')
    @folder_id = ->
      $(@element).data('folder-id')
    @nests = ->
      $(@element).data('nests')




class BookmarkManager
  constructor: ->
    @folders = {}
    @bookmarks = {}
    @max_folder_nest = null
    @add_folder = (folder) ->
      unless folder.id() in @folders
        @folders[folder.id()] = folder

    @add_bookmark = (bookmark) =>
      #if bookmark.folder_id() in @folders
      #console.log(@folders[bookmark.folder_id()])
      folder = @folders[bookmark.folder_id()]
      folder.add_bookmark(bookmark)

      unless bookmark.id() in @bookmarks
        @bookmarks[bookmark.id()] = bookmark 



    @folder_count = () ->
      #連想配列の要素数
      Object.keys(@folders).length
    @root_folders = () -> 
      ret = []
      $.each @folders, (index, folder) =>
        if folder.is_root() ==  true
          ret.push(folder)
      ret
    @nests_by = (nest_count) -> 
      ret = []
      $.each @folders, (index, folder) =>
        if folder.nests() == nest_count
          ret.push(folder)
      $.each @bookmarks, (index, bookmark) =>
        if bookmark.nests() == nest_count
          ret.push(bookmark)
      ret
    @send_clicked = (type, id) =>
      if type == 'folder'
        if folder = @folders[id]
          #console.log(folder.child_ids())
          $.each folder.child_ids(), (index, child_id) ->
            #自身のメソッドを呼ぶとき
            child = find.call @, 'folder', child_id
            child.show()
    #private method
    find = (type, id) =>
      #console.log(id)
      if type == 'folder'
        if folder = @folders[id]
          folder
        else
          #console.log('not found')
    @count_tree = (folder_id, layer_id, retval) =>
      #console.log('layer_id ='+layer_id)
      #console.log(retval)
      folder = find.call @, 'folder', folder_id
      #console.log('folder.id  '+ folder.id())
      #console.log(folder.title())
      #console.log(folder.bookmark_count())
      if retval[layer_id] > 0
        #console.log("retval[layer_id]があります: #{retval[layer_id]}")
        retval[layer_id] += 1
      else
        #console.log("retval[layer_id]ありません: #{retval[layer_id]}")
        retval[layer_id] = 1
      retval[layer_id] += folder.child_ids().length

      retval[layer_id+1] = folder.bookmark_count()
      if folder.child_ids().length > 0
        layer_id += 1
        #console.log("child id is #{folder.child_ids()}")
        $.each folder.child_ids(), (index, id) =>
          #console.log("child id #{id}")
          retval = @count_tree.call @, id, layer_id, retval
      #console.log(retval)
      retval


class Drawer
  constructor: (canvas) ->
    @canvas = canvas
    @ctx = @canvas.getContext('2d')
    #@canvas.width = 800;
    #@canvas.height = 600;
    #@canvas.style.width = '800px';
    #@canvas.style.height = '600px';
    @center = {x: @canvas.width / 2, y: @canvas.height / 2 }
    @write_folder = (x, y, title) =>
      width = 100
      height = 50
      x = x - (width / 2)
      y = y - (height / 2)
      if ( !@canvas || !@canvas.getContext )
        #console.log('no canvas')
        return false
      @ctx = @canvas.getContext('2d')
      @ctx.lineWidth = 1
      @ctx.lineJoin = "round"
      @ctx.beginPath()
      @ctx.strokeRect(x, y, width, height)
      @ctx.stroke()
      @ctx.font = "italic 10px 'ＭＳ Ｐゴシック'";
      @ctx.strokeStyle = "blue";
      text_left_margin = this.text_position(width, height, title)
      @ctx.strokeText(title, x + text_left_margin, y+25, 800);
    @text_position = (area_width, area_height, text) =>
      length = @ctx.measureText(text).width
      (area_width - length) / 2
    @write_circle = () =>
      @ctx.beginPath()
      startAngle = 0
      endAngle = 360 * Math.PI / 180
      @ctx.arc(@center.x, @center.y, 100, startAngle, endAngle, false)
      @ctx.stroke();

  write_root: () =>
    this.write_folder(@center.x, @center.y, 'root')
    this.write_circle()
 
class Mapper
  constructor: (width, height) ->
    @width = width
    @height = height
    @center = {x: @width / 2, y: @height / 2 }
    @counts_by_layer = [] #階層ごとにフォルダ,bookmarkが何個あるか
    @base_radius_by_layer = [200, 300, 400, 500]
    @radius_by_layer = []
    @adjust_radius = () =>
      #階層ごとにフォルダ,bookmarkの上限に達している場合は階層の半径を広げる
      @radius_by_layer = @base_radius_by_layer
    @mapping = () =>
      #rootの各フォルダからchildsで降っていきそれぞれのx,yをきめる
      #[{folder_id_1: {x: 1, y: 2}}, {},{}] みたいな配列をかえす


jQuery ($) ->
  canvas = $('.canvas')[0]
  bm = new BookmarkManager()
  bm.max_folder_nest = $('div.mindmap').data('max-folder-nest')

  $('div.folder').each (index, element) =>
    folder = new Folder(element)
    bm.add_folder(folder)
    #$(element).click (e) ->
    #  bm.send_clicked('folder', folder.id())
    #  e.preventDefault()
    #  e.stopPropagation()
  $('div.bookmark').each (index, element) =>
    bookmark = new Bookmark(element)
    bm.add_bookmark(bookmark)
  #$.each bm.root_folders(), (index, element) =>
    #element.show()
  mapper = new Mapper(canvas.width, canvas.height)
  for i in [1..bm.max_folder_nest] by 1
    #console.log('---nest level' + i)
    mapper.counts_by_layer[i] = bm.nests_by(i).length
  mapper.adjust_radius()
  #console.log(mapper.counts_by_layer)
  #縦方向に操作
  #[root_folder_id -> {layer_1: 3こ, layer_2: 4こ}, root_folder_id -> {layer....]
  ret = []
  #folder = bm.find('folder', 6)
  ret = bm.count_tree(100, 1, [])
  console.log(ret)
  ret = bm.count_tree(102, 1, [])
  console.log(ret)
 


  #mapper.root_position()
  drawer = new Drawer(canvas)
  drawer.write_root()
  
#  for i in [1..bm.max_folder_nest] by 1
#    console.log('---nest level' + i)
#    $.each bm.nests_by(i), (index, folder) ->
#      console.log(folder.id() + folder.title())


