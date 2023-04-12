class Report < ApplicationRecord

def self.import(link)
    spreadsheet = open_spreadsheet(link)
    header = spreadsheet.row(1)
    score_hash = {}
    report = new
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      Scoring.create_score_hash(score_hash, row)
    end
    sh = score_hash.values
    puts sh
    reverse_score_hash = Scoring.incorporate_reverse_scores(score_hash)
    rsh =reverse_score_hash.values
    puts rsh
    binary_score_hash = Scoring.convert_score_to_binary(reverse_score_hash)
    bsh = binary_score_hash.values
    puts bsh
    dim_hash = Scoring.determine_dimensional_score(binary_score_hash)
    puts dim_hash
    str_parse = link[1].original_filename.split(".")[0]
    name = str_parse.split("_")[0]
    date = str_parse.split("_")[1]
    report.name =  name || Faker::Name.name
    report.dim_score = dim_hash
    if date
      report.date = Date.parse(date)
    else
      report.date = Date.today
    end  
    puts score_hash
    report.save!
    generate_excel(str_parse, sh, rsh, bsh, dim_hash) 
  end
  
  def self.open_spreadsheet(link)
    case File.extname(link[1].original_filename)
    when ".csv" then Roo::Csv.new(link[1].path)
    when ".xls" then Roo::Excel.new(link[1].path)
    when ".xlsx" then Roo::Excelx.new(link[1].path)
    else raise "Unknown file type: #{link[1].original_filename}"
    end
  end

  def self.generate_excel(name,response,reverse, binary, dim)
    workbook = WriteXLSX.new("#{name}_processed.xlsx")

    ## A Simple Workbookworksheet_scores.write(0, 0, "Questions")
    worksheet_scores = workbook.add_worksheet("Scores")
    worksheet_scores.write(0, 0, "Questions")
    worksheet_scores.write(0, 1, "Response")
    worksheet_scores.write(0, 2, "Reverse")
    worksheet_scores.write(0, 3, "Binary")

    (1..36).each do |num|
      worksheet_scores.write(num, 0, num)
    end

    response.each_with_index do |s,i|
      worksheet_scores.write(i+1, 1, s)
    end 
 
    reverse.each_with_index do |r,i|
      worksheet_scores.write(i+1, 2, r)
    end 

    binary.each_with_index do |b,i|
      worksheet_scores.write(i+1, 3, b)
    end

    worksheet_interpretation = workbook.add_worksheet("Interpretation")
    worksheet_interpretation.write(0, 0, "Category")
    worksheet_interpretation.write(0, 1, "Average")
 
    dim.each_with_index do |(cat,avg),i|
      worksheet_interpretation.write(i+1, 0, cat)
      worksheet_interpretation.write(i+1, 1, avg)
    end

    workbook.close
  end
end
