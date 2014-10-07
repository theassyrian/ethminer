/*
    This file is part of cpp-ethereum.

    cpp-ethereum is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    cpp-ethereum is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with cpp-ethereum.  If not, see <http://www.gnu.org/licenses/>.
*/
/**
 * @author Christian <c@ethdev.com>
 * @date 2014
 * Solidity parser.
 */

#pragma once

#include "libsolidity/AST.h"

namespace dev {
namespace solidity {

class Scanner;

class Parser
{
public:
    ptr<ASTNode> parse(Scanner& _scanner);

private:
    class ASTNodeFactory;

    /// Start position of the current token
    int getPosition() const;
    /// End position of the current token
    int getEndPosition() const;

    /// Parsing functions for the AST nodes
    /// @{
    ptr<ContractDefinition> parseContractDefinition();
    ptr<FunctionDefinition> parseFunctionDefinition(bool _isPublic);
    ptr<StructDefinition> parseStructDefinition();
    ptr<VariableDeclaration> parseVariableDeclaration();
    /// @}

    /// Helper functions
    /// @{
    /// If current token value is not _value, throw exception otherwise advance token.
    void expectToken(Token::Value _value);
    std::string expectIdentifier();
    void throwExpectationError(const std::string& _description);
    /// @}

    Scanner* m_scanner;
};

} }
