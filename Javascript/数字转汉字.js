function numToUpper(numStr) {
  numStr = numStr.toString()
  let number = new Array("零","一","二","三","四","五","六","七","八","九")
  let unitList = new Array("十", "百", "千", "万", "十", "百", "千", "亿")
  let neg = '负'
  let two = '两'
  let unit = (i)=> i>0 ? unitList[(i-1)%8] : ""
  var result = ''
  var index = 0, length = 0
  if(numStr.charAt(index) == '-') {
    result+=neg
    ++index
  }
  while(numStr.charAt(index) == '0') ++index
  numStr = numStr.substring(index)
  index = 0
  while(parseInt(numStr.charAt(length)) >= 0) ++length
  if(length ==0) {
    return number[0]
  }
  var i = 0, zeroflag = -1, wanflag = 0
  while(i < length) {
    let weight = length - 1 - i
    let c = parseInt(numStr.charAt(i))
    if(c == 0) {
      if(zeroflag == 0) {
        wanflag = (weight+1) %8 != 0
      }
      if(wanflag == 1 && weight % 8 == 4) {
        result += unit(weight)
        wanflag = 0
      }
      if(weight % 8 == 0) {
        result += unit(weight)
        wanflag = 0
      }
      zeroflag = 1
    } else {
      if(zeroflag == 1) {
        result += number[0]
      }
      if(!( i == 0 && c == 1 && length%4 == 2 )) {
        if( c == 2 && (weight % 4 == 0 && weight !=0 && zeroflag != 0 || weight % 4 > 1) ) {
          result += two
        } else {
          result += number[c]
        }
      }
      result += unit(weight)
      zeroflag = 0
    }
    ++i
  }
  return result
}


function numToBigUpper(numStr) {
  numStr = numStr.toString()
  let number = new Array("零","一","二","三","四","五","六","七","八","九")
  let unitList = new Array("十", "百", "千")
  let bigUnitList = new Array("万","亿","兆","京","垓","秭","壤","沟","涧","正","载")
  let neg = '负'
  let two = '两'
  let unit = (i)=> {
    if(i<=0) return ""
    i = (i-1) % ((unitList.length + 1) * bigUnitList.length) + 1
    let n = i % (unitList.length+1)
    return (n == 0) ? bigUnitList[ i / (unitList.length+1) - 1] : unitList[n - 1]
  }
  var result = ''
  var index = 0, length = 0
  if(numStr.charAt(index) == '-') {
    result+=neg
    ++index
  }
  while(numStr.charAt(index) == '0') ++index
  numStr = numStr.substring(index)
  index = 0
  while(parseInt(numStr.charAt(length)) >= 0) ++length
  if(length ==0) {
    return number[0]
  }
  var i = 0, zeroflag = -1, wanflag = 0
  while(i < length) {
    let weight = length - 1 - i
    let c = parseInt(numStr.charAt(i))
    if(c == 0) {
      if(zeroflag == 0) {
        wanflag = (weight+1) %8 != 0
      }
      if(wanflag == 1 && weight % 8 == 4) {
        result += unit(weight)
        wanflag = 0
      }
      if(weight % 8 == 0) {
        result += unit(weight)
        wanflag = 0
      }
      zeroflag = 1
    } else {
      if(zeroflag == 1) {
        result += number[0]
      }
      if(!( i == 0 && c == 1 && length%4 == 2 )) {
        if( c == 2 && (weight % 4 == 0 && weight !=0 && zeroflag != 0 || weight % 4 > 1) ) {
          result += two
        } else {
          result += number[c]
        }
      }
      result += unit(weight)
      zeroflag = 0
    }
    ++i
  }
  return result
}