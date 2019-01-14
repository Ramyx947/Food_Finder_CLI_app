# module is used as a mixed-in 
# borrows from RoR's number_to_currency method

module NumberHelper
    def number_to_currency(number, options={})
    # unit: £$
    unit        = options[:unit]      || '£'
    # how many decimals it should have
    precision   = options[:precision] || 2
    # what it should use between numbers as a delimiter 1,000
    delimiter   = options[:delimiter] || ','
    # decimal separator = 10.54
    separator   = options[:separator] || '.'
# we remove the separator(asked not to use decimal places) and split it on the decimal
# turn it into a string and split it on the decimal
# results in two parts: the integer half and the decimal half
    separator = '' if precision == 0
    integer, decimal = number.to_s.split('.')
# the integer half = loop through and counting backwards every 3 numbers and put the delimiter 
    i= integer.length
    until i <= 3
        i -= 3
        integer= integer.insert(i, delimiter)
    end
# if precision = 0 then there is no decimal
    if precision == 0
        precise_decimal = ' '
    else
        # check decimal is not nil
        decimal ||= "0"
        # check decimal is not too large
        decimal = decimal[0, precision-1]
        # check decimal is not too short
        precise_decimal = decimal.ljust(precision, "0")
    end
    return unit + integer + separator + precise_decimal
    end
end 
