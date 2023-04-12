class Scoring

    def calculate(hash)

    end

    def self.create_score_hash(hash, entry)
        hash[entry["Question"]] = entry["Response"]
        hash
    end

    def self.incorporate_reverse_scores(hash)
        reverse_hash = { 1 => 4, 2 => 3, 3 => 2, 4 => 1} 
        questions = [7,10,21,25,31,32]
        hash.each do |q, response|
            if questions.include?(q)
                hash[q] = reverse_hash[response] if reverse_hash[response]
            end
        end
        hash
    end

    def self.convert_score_to_binary(hash)
        hash.each do |q, response|
          response.to_i > 2 ? hash[q] =0 : hash[q] = 1 unless response == " -"
        end
        hash
    end
    
    def self.determine_dimensional_score(hash)
        dimension_template = {"DEP" => [3,5,7,8,10,12,25],
                              "SOM" => [14,15,16,18,23,30,35],
                              "MEM" => [20,33,36],
                              "VAS" => [19,27], 
                              "ANX" => [2,4,6,9],
                              "SEX" => [24,31,34],
                              "SLE" => [1,11,29],
                              "MEN" => [17,22,26,28],
                              "ATT" => [21,32]}
        dim_hash = {}              
        dimension_template.each do |dim,qs|
            value = 0
            count = 0
            qs.each do |q|
                value += hash[q] unless hash[q] == " -"
                count += 1
            end
            dim_hash[dim] = (value/count.to_f).round(1)
        end
        dim_hash
    end

    def self.bar_chart_colors(data)
        colors=[]
        data.values.each do |val|
            if val < 0.5
                colors << "#008000"
            elsif val == 0.5
                colors << "#FFCE30"
            else 
                colors << "#FF0000"
            end    
        end
        colors
    end

    def self.report_outcomes(hash)
        array = []
            puts("Inside report outcomes #{hash}")
        hash.each do |condition, value|
            sub_array = []
            sub_array << condition
            if value < 0.5
                sub_array << 'green'
            elsif value == 0.5
                sub_array << 'yellow'
            else 
                sub_array << 'red'
            end
            sub_array << outcomes[condition.to_sym][sub_array[1].to_sym]
            array << sub_array
        end
        array
    end

    def self.outcomes
        {"ATT": {"red": 'Your response indicates that you experience low self-esteem and have a low self-image. Further
                    assessment is needed.',
                 "yellow": 'Your responses indicate that you experience mild to moderate levels of low self-esteem and
                 self-image. This can be attributed to various reasons; detailed assessment is recommended.',
                 "green": 'Your responses indicate a state of high or moderate self-esteem and self-image that keeps
                 you feeling happy.'},
         "MEN": {"red": 'Your responses indicate increased difficulty in coping with the many menstrual symptoms you
                 face. This could be due to many reasons; detailed assessment is recommended.',
                 "yellow": 'Your responses indicate that you experience mild to moderate menstrual symptoms that do
                    not pose as a serious problem to you.',
                 "green": 'Your responses indicate a state of low menstrual symptoms that you are able to manage and
                    cope with properly.'},
         "SLE": {"red": 'Your responses indicate increased sleep issues where you find it hard to sleep, stay asleep
                and/or relax completely during sleep. This could be due to various factors; detailed assessment is
                recommended.',
                 "yellow": 'Your responses indicate that you experience mild to moderate levels of sleep issues that do
                 not cause much disruption to your life.',
                 "green": 'Your responses indicate a state of high or moderate sleep levels where your body is able to
                 get plenty of rest and relaxation.'},
         "SEX": {"red": 'Your responses indicate that you have an increased difficulty in having a healthy sexual life and
                are unable to enjoy your sexual life. This could be attributed to various reasons; detailed assessment
                is recommended.',
                 "yellow": 'Your responses indicate that you experience mild to moderate levels of healthy sexual
                 behaviours.',
                 "green": 'Your responses indicate a state where you experience healthy sexual behaviours and are
                 overall satisfied with your sexual life.'},
         "ANX": {"red": 'Your responses indicate that you have high anxiety symptoms and find it is disrupting your
                regular day-to-day functioning. Detailed assessment is recommended.',
                 "yellow": 'Your responses indicate that you experience mild to moderate vasomotor symptoms and are
                 able to manage it from time to time.',
                 "green": 'Your responses indicate a state of low anxiety symptoms.'},
         "VAS": {"red": 'Your responses indicate increased difficulty in coping with the multiple vasomotor symptoms.
                Detailed assessment is recommended.',
                 "yellow": 'Your responses indicate that you experience mild to moderate vasomotor symptoms and are
                 able to manage it from time to time.',
                 "green": 'Your responses indicate a state where you experience minimal vasomotor symptoms and are
                 able to manage it in an accurate manner.'},
         "MEM": {"red": 'Your responses indicate difficulty in maintaining concentration, recalling or reduced attention
                 span. Detailed assessment is recommended to ascertain the cause.',
                 "yellow": 'Your responses indicate moderate to mild difficulty in maintaining concentration, recalling or
                 reduced attention span. Detailed assessment is recommended to ascertain the cause.',
                 "green": 'Your responses indicate a state of high memory levels that allow you to maintain and
                 increase concentration while seeing an increase in attention span and recall.'},
         "SOM": {"red": 'Your responses indicate increased physical issues that can be attributed to your reproductive
                  health dysfunction. Detailed assessment is recommended.',
                 "yellow": 'Your responses indicate that you experience mild to moderate levels of affect on your
                 physical health due to reproductive dysfunction.',
                 "green": 'Your responses indicate that you experience low levels of physical issues that could
                 contribute to reproductive dysfunction.'},
         "DEP": {"red": 'Your responses indicate that you experience low levels of mood, energy and interest on a
                  frequent basis. This can be attributed to various reasons; detailed assessment is recommended.',
                 "yellow": 'Your responses indicate that you experience mild to moderate levels of low mood, Low
                 Energy and interest on a frequent basis. This can be attributed to various reasons; detailed
                 assessment is recommended.',
                 "green": 'Your responses indicate a state of high or moderate mood that keeps your energy levels high
                 and helps you maintain your energy levels on a regular basis.'}}      
    end    

    

end    